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
    NSString *promiseA = @"A";
    NSString *promiseB = @"B";
    
    context(@"With a promise kept block", ^{
        
        beforeEach(^{
            TKPromiseKeptBlock promiseKept = ^{
                promiseCompleteValue = @"Promise kept";
            };
            
            promise = [[TKPromise alloc] initWithPromiseKeptBlock:promiseKept
                                               promiseFailedBlock:NULL
                                             promiseResolvedBlock:NULL
                                                      commitments:promiseA, promiseB, nil];
        });
        
        it(@"should execute the block when the promise is kept", ^{
            [promise keepCommitment:promiseA];
            [promise keepCommitment:promiseB];
            [[promiseCompleteValue should] equal:@"Promise kept"];
        
        });
        
    });
    
});
SPEC_END
