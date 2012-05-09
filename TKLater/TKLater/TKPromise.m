//
//  TKLater.m
//  TKLater
//
//  Created by Tony Hillerson on 5/7/12.
//  Copyright (c) 2012 Tack Mobile, LLC. All rights reserved.
//

#import "TKPromise.h"

@interface TKPromise (Private)
- (void) attemptToKeep;
- (void) raiseIfAlreadyKept:(NSString *)commitment;
- (void) raiseIfAlreadyFailed:(NSString *)commitment;
- (void) commitmentFailed;
@end

@implementation TKPromise

- (id) initWithPromiseKeptBlock:(TKPromiseKeptBlock)pkb
             promiseFailedBlock:(TKPromiseFailedBlock)pfb
                    commitments:(NSString *)aCommitment, ... {
    if (self = [super init]) {
        commitments = [NSMutableArray array];
        
        va_list commitmentArgs;
        va_start(commitmentArgs, aCommitment);
        for (NSString *commitment = aCommitment; commitment != nil; commitment = va_arg(commitmentArgs, NSString*)) {
            [commitments addObject:commitment];
        }
        va_end(commitmentArgs);
        
        keptCommitments = [NSMutableArray arrayWithCapacity:[commitments count]];
        failedCommitments = [NSMutableSet setWithCapacity:[commitments count]];
        
        promiseKeptBlock = pkb;
        promiseFailedBlock = pfb;
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

- (NSInteger) countOfCommitmentsKept {
    return [keptCommitments count];
}

- (NSInteger) countOfCommitmentsFailed {
    return [failedCommitments count];
}

- (NSInteger) countOfCommitmentsToKeep {
    return [commitments count] - [keptCommitments count] - [failedCommitments count];
}

- (void) keepCommitment:(NSString *)commitment {
    [self raiseIfAlreadyKept:commitment];
    [self raiseIfAlreadyFailed:commitment];
    [keptCommitments addObject:commitment];
    [self attemptToKeep];
}

- (void) failCommitment:(NSString *)commitment {
    [self raiseIfAlreadyFailed:commitment];
    [self raiseIfAlreadyKept:commitment];
    [failedCommitments addObject:commitment];
    [self commitmentFailed];
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

- (void) commitmentFailed {
    // Failure block should only be called once.
    // The assumption is that this is not the first failure, the failure block has already been called.
    if ([self countOfCommitmentsFailed] == 1) { 
        if (promiseFailedBlock) promiseFailedBlock();
    }
}

- (void) attemptToKeep {
    if ([self isKept]) {
        if (promiseKeptBlock) promiseKeptBlock();
    }
}

@end
