//
//  TKLater.h
//  TKLater
//
//  Created by Tony Hillerson on 5/7/12.
//  Copyright (c) 2012 Tack Mobile, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TKPromiseKeptBlock)();
typedef void (^TKPromiseFailedBlock)();
typedef void (^TKPromiseResolveBlock)();

#define kTKPromiseCommitmentAlreadyKeptError @"kTKPromiseCommitmentAlreadyKeptError"
#define kTKPromiseCommitmentAlreadyFailedError @"kTKPromiseCommitmentAlreadyFailedError"
#define kTKPromiseNoSuchCommitmentError @"kTKPromiseNoSuchCommitmentError"

@interface TKPromise : NSObject {
    TKPromiseKeptBlock promiseKeptBlock;
    TKPromiseFailedBlock promiseFailedBlock;
    TKPromiseResolveBlock resolveBlock;
    NSMutableArray *commitments;
    NSMutableArray *keptCommitments;
    NSMutableSet *failedCommitments;
}

- (id) initWithPromiseKeptBlock:(TKPromiseKeptBlock)promiseKeptBlock
             promiseFailedBlock:(TKPromiseFailedBlock)promiseFailedBlock
           promiseResolvedBlock:(TKPromiseResolveBlock)resolveBlock
                    commitments:(NSString *)aCommitment, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL) isCommittedTo:(NSString *)commitment;
- (BOOL) isCommitmentKept:(NSString *)commitment;
- (BOOL) isCommitmentFailed:(NSString *)commitment;
- (BOOL) isKept;
- (BOOL) isFailed;
- (BOOL) isResolved;
- (NSInteger) countOfCommitmentsKept;
- (NSInteger) countOfCommitmentsFailed;
- (NSInteger) countOfCommitmentsToKeep;
- (void) keepCommitment:(NSString *)commitment;
- (void) failCommitment:(NSString *)commitment;

@end
