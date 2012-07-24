//
//  TKLater.m
//  TKLater
//
//  Created by Tony Hillerson on 5/7/12.
//  Copyright (c) 2012 Tack Mobile, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TKPromise.h"

@interface TKPromise () {
    BOOL promiseResolved;
}

- (void) attemptToKeep;
- (void) raiseIfAlreadyResolved;
- (void) raiseIfAlreadyKept:(NSString *)commitment;
- (void) raiseIfAlreadyFailed:(NSString *)commitment;
- (void) raiseIfNeverCommittedTo:(NSString *)commitment;
- (void) commitmentFailed;
- (void) attemptToResolve;
@end

@implementation TKPromise
@synthesize delegate;

- (id) initWithPromiseKeptBlock:(TKPromiseKeptBlock)pkb
             promiseFailedBlock:(TKPromiseFailedBlock)pfb
           promiseResolvedBlock:(TKPromiseResolvedBlock)prb
                    commitments:(NSString *)aCommitment, ... {
    if (self = [super init]) {
        commitments = [NSMutableSet set];
        
        va_list commitmentArgs;
        va_start(commitmentArgs, aCommitment);
        for (NSString *commitment = aCommitment; commitment != nil; commitment = va_arg(commitmentArgs, NSString*)) {
            [commitments addObject:commitment];
        }
        va_end(commitmentArgs);
        
        keptCommitments = [NSMutableSet setWithCapacity:[commitments count]];
        failedCommitments = [NSMutableSet setWithCapacity:[commitments count]];
        
        promiseKeptBlock = pkb;
        promiseFailedBlock = pfb;
        resolveBlock = prb;
        
        promiseResolved = NO;
    }
    return self;

}

- (BOOL) isCommittedTo:(NSString *)commitment {
    return [commitments containsObject:commitment];
}

- (BOOL) isCommitmentKept:(NSString *)commitment {
    return [keptCommitments containsObject:commitment];
}

- (BOOL) isCommitmentFailed:(NSString *)commitment {
    return [failedCommitments containsObject:commitment];
}

- (BOOL) isKept {
    return [commitments count] == [keptCommitments count];
}

- (BOOL) isFailed {
    return [failedCommitments count] > 0;
}

- (BOOL) isResolved {
    return promiseResolved;
}

- (NSInteger) countOfCommitmentsKept {
    return [keptCommitments count];
}

- (NSInteger) countOfCommitmentsFailed {
    return [failedCommitments count];
}

- (NSInteger) countOfCommitmentsToKeep {
    return [commitments count] - [keptCommitments count] - [failedCommitments count];
}

- (void) addCommitment:(NSString *)commitment {
    @synchronized(self) {
        [self raiseIfAlreadyResolved];
        [self raiseIfAlreadyKept:commitment];
        [self raiseIfAlreadyFailed:commitment];
        [commitments addObject:commitment];
    }
}

- (void) addCommitments:(NSSet *)newCommitments {
    // Add these one at a time to get error coverage
    [newCommitments enumerateObjectsUsingBlock:^(NSString *commitment, BOOL *stop) {
        [self addCommitment:commitment];
    }];
}

- (void) keepCommitment:(NSString *)commitment {
    @synchronized(self) {
        [self raiseIfNeverCommittedTo:commitment];
        [self raiseIfAlreadyKept:commitment];
        [self raiseIfAlreadyFailed:commitment];
        [keptCommitments addObject:commitment];
        if ([delegate respondsToSelector:@selector(promise:didKeepCommitment:)]) {
            [delegate promise:self didKeepCommitment:commitment];
        }
        [self attemptToKeep];
    }
}

- (void) failCommitment:(NSString *)commitment {
    @synchronized(self) {
        [self raiseIfNeverCommittedTo:commitment];
        [self raiseIfAlreadyFailed:commitment];
        [self raiseIfAlreadyKept:commitment];
        [failedCommitments addObject:commitment];
        if ([delegate respondsToSelector:@selector(promise:didFailCommitment:)]) {
            [delegate promise:self didFailCommitment:commitment];
        }
        [self commitmentFailed];
    }
}

- (void) raiseIfAlreadyResolved {
    if ([self isResolved]) {
        [NSException raise:kTKPromiseAlreadyResolvedError
                    format:[NSString stringWithFormat:@"Promise already resolved"]];
    }
}

- (void) raiseIfAlreadyKept:(NSString *)commitment {
    if ([self isCommitmentKept:commitment]) {
        [NSException raise:kTKPromiseCommitmentAlreadyKeptError
                    format:[NSString stringWithFormat:@"Commitment '%@' has already been kept", commitment]];
    }
}

- (void) raiseIfAlreadyFailed:(NSString *)commitment {
    if ([self isCommitmentFailed:commitment]) {
        [NSException raise:kTKPromiseCommitmentAlreadyFailedError
                    format:[NSString stringWithFormat:@"Commitment '%@' has already failed", commitment]];
    }   
}

- (void) raiseIfNeverCommittedTo:(NSString *)commitment {
    if (![self isCommittedTo:commitment]) {
        [NSException raise:kTKPromiseNoSuchCommitmentError
                    format:[NSString stringWithFormat:@"Never committed to '%@'", commitment]];
    }
}

- (void) commitmentFailed {
    // Failure block should only be called once.
    // The assumption is that this is not the first failure, the failure block has already been called.
    if ([self countOfCommitmentsFailed] == 1) { 
        if (promiseFailedBlock) promiseFailedBlock();
        if ([delegate respondsToSelector:@selector(promiseDidFail:)]) {
            [delegate promiseDidFail:self];
        }       
    }
    [self attemptToResolve];
}

- (void) attemptToKeep {
    if ([self isKept]) {
        if (promiseKeptBlock) promiseKeptBlock();
        if ([delegate respondsToSelector:@selector(promiseKept:)]) {
            [delegate promiseKept:self];
        }       
    }
    [self attemptToResolve];
}

- (void) attemptToResolve {
    if ([self countOfCommitmentsToKeep] == 0) {
        promiseResolved = YES;
        if (resolveBlock) resolveBlock();
        if ([delegate respondsToSelector:@selector(promiseDidResolve:)]) {
            [delegate promiseDidResolve:self];
        }       
    }
}

@end
