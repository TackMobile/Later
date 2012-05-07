//
//  TKLater.h
//  TKLater
//
//  Created by Tony Hillerson on 5/7/12.
//  Copyright (c) 2012 Tack Mobile, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKPromise : NSObject {
    NSMutableArray *commitments;
    NSMutableArray *keptCommitments;
}

- (id) initWithCommitments:(NSString *)aCommitment, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL) isCommittedTo:(NSString *)commitment;
- (BOOL) isCommitmentKept:(NSString *)commitment;
- (void) keepCommitment:(NSString *)commitment;

@end
