//
//  TKLaterTests.h
//  TKLaterTests
//
//  Created by Tony Hillerson on 5/7/12.
//  Copyright (c) 2012 Tack Mobile, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "TKPromise.h"

SPEC_BEGIN(TKPromiseFailedSpec)

describe(@"A Promise", ^{
    
    __block TKPromise *promise = nil;
    __block NSNumber *promiseCompleteValue = nil;
    NSString *promiseA = @"A";
    NSString *promiseB = @"B";
    
    context(@"with a promise failed block", ^{
        
        beforeEach(^{
            __block NSUInteger callCount = 0;

            TKPromiseFailedBlock promiseFailed = ^{
                callCount++;
                promiseCompleteValue = [NSNumber numberWithInt:callCount];
            };
            
            promise = [[TKPromise alloc] initWithPromiseKeptBlock:NULL
                                               promiseFailedBlock:promiseFailed
                                                      commitments:promiseA, promiseB, nil];
        });
        
        it(@"should execute the failure block when one commitment fails", ^{
            [promise failCommitment:promiseA];
            [[expectFutureValue(promiseCompleteValue) shouldEventually] equal:[NSNumber numberWithInt:1]];
            
        });
        
        it(@"should execute the failure block only once when more than one commitment fails", ^{
            [promise failCommitment:promiseA];
            [promise failCommitment:promiseB];
            [[expectFutureValue(promiseCompleteValue) shouldEventually] equal:[NSNumber numberWithInt:1]];
            
        });
        
    });
    
});
SPEC_END