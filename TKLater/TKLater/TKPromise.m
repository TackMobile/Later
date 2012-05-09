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

- (BOOL) isKept {
    return [commitments count] == [keptCommitments count];
}

- (BOOL) isFailed {
    return [failedCommitments count] > 0;
}

- (NSInteger) countOfCommitmentsKept {
    return [keptCommitments count];
}

- (NSInteger) countOfCommitmentsToKeep {
    return [commitments count] - [keptCommitments count];
}

- (void) keepCommitment:(NSString *)commitment {
    [keptCommitments addObject:commitment];
    [self attemptToKeep];
}

- (void) failCommitment:(NSString *)commitment {
    [failedCommitments addObject:commitment];
}

- (void) attemptToKeep {
    if ([self isKept]) {
        promiseKeptBlock();
    }
}

@end
