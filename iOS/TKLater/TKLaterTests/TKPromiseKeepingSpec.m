//
//  TKLaterTests.h
//  TKLaterTests
//
//  Created by Tony Hillerson on 5/7/12.
//  Copyright (c) 2012 Tack Mobile, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "TKPromise.h"

SPEC_BEGIN(TKPromiseKeepingSpec)

describe(@"A Promise", ^{
    
    __block TKPromise *promise = nil;
    __block NSString *promiseCompleteValue = nil;
    __block NSInteger commitmentsKept = 0;
    NSString *promiseA = @"A";
    NSString *promiseB = @"B";
    
    context(@"With a promise kept block and a commitment kept block", ^{
        
        beforeEach(^{
            TKPromiseKeptBlock promiseKept = ^{
                promiseCompleteValue = @"Promise kept";
            };
            TKCommitmentKeptBlock commitmentKept = ^(NSString *commitment) {
                commitmentsKept++;
            };
            
            promise = [[TKPromise alloc] initWithPromiseKeptBlock:promiseKept
                                               promiseFailedBlock:NULL
                                             promiseResolvedBlock:NULL
                                                      commitments:promiseA, promiseB, nil];
            promise.commitmentKeptBlock = commitmentKept;
        });
        
        it(@"should execute the block when the promise is kept", ^{
            [promise keepCommitment:promiseA];
            [promise keepCommitment:promiseB];
            [[promiseCompleteValue should] equal:@"Promise kept"];
            
            [[theValue(commitmentsKept) should] equal:theValue(2)];
        });
        
    });
    
});
SPEC_END
