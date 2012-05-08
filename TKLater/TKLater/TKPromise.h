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

@interface TKPromise : NSObject {
    TKPromiseKeptBlock promiseKeptBlock;
    TKPromiseFailedBlock promiseFailedBlock;
    NSMutableArray *commitments;
    NSMutableArray *keptCommitments;
}

- (id) initWithPromiseKeptBlock:(TKPromiseKeptBlock)promiseKeptBlock
             promiseFailedBlock:(TKPromiseFailedBlock)promiseFailedBlock
                    commitments:(NSString *)aCommitment, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL) isCommittedTo:(NSString *)commitment;
- (BOOL) isCommitmentKept:(NSString *)commitment;
- (BOOL) isKept;
- (NSInteger) countOfCommitmentsKept;
- (NSInteger) countOfCommitmentsToKeep;
- (void) keepCommitment:(NSString *)commitment;

@end
