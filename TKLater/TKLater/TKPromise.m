//
//  TKLater.m
//  TKLater
//
//  Created by Tony Hillerson on 5/7/12.
//  Copyright (c) 2012 Tack Mobile, LLC. All rights reserved.
//

#import "TKPromise.h"

@implementation TKPromise

- (id) initWithCommitments:(NSString *)aCommitment, ... {
    if (self = [super init]) {
        commitments = [NSMutableArray array];
        
        va_list commitmentArgs;
        va_start(commitmentArgs, aCommitment);
        for (NSString *commitment = aCommitment; commitment != nil; commitment = va_arg(commitmentArgs, NSString*)) {
            [commitments addObject:commitment];
        }
        va_end(commitmentArgs);
        
        keptCommitments = [NSMutableArray arrayWithCapacity:[commitments count]];
    }
    return self;
}

- (BOOL) isCommittedTo:(NSString *)commitment {
    return [commitments containsObject:commitment];
}

- (BOOL) isCommitmentKept:(NSString *)commitment {
    return [keptCommitments containsObject:commitment];
}

- (void) keepCommitment:(NSString *)commitment {
    [keptCommitments addObject:commitment];
}

@end
