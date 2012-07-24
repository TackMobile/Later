//
//  TKLaterTests.h
//  TKLaterTests
//
//  Created by Tony Hillerson on 5/10/12.
//  Copyright (c) 2012 Tack Mobile, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "TKPromise.h"

SPEC_BEGIN(TKPromiseDelegateSpec)

describe(@"A Promise", ^{
    
    __block id mockDelegate;
    __block TKPromise *promise = nil;
    NSString *promiseA = @"A";
    NSString *promiseB = @"B";
    
    context(@"with a delegate", ^{
        
        beforeEach(^{
            mockDelegate = [KWMock mockForProtocol:@protocol(TKPromiseDelegate)];
            [mockDelegate stub:@selector(promise:didKeepCommitment:)];
            [mockDelegate stub:@selector(promise:didFailCommitment:)];
            [mockDelegate stub:@selector(promiseKept:)];
            [mockDelegate stub:@selector(promiseDidFail:)];
            [mockDelegate stub:@selector(promiseDidResolve:)];
            
            promise = [[TKPromise alloc] initWithPromiseKeptBlock:NULL
                                               promiseFailedBlock:NULL
                                             promiseResolvedBlock:NULL
                                                      commitments:promiseA, promiseB, nil];
            
            promise.delegate = mockDelegate;
        });
        
        it(@"should call the delegate when a commitment is kept", ^{
            [[mockDelegate should] receive:@selector(promise:didKeepCommitment:)
                             withArguments:promise, promiseA];
            [promise keepCommitment:promiseA];
        });
        
        it(@"should call the delegate when a commitment fails", ^{
            [[mockDelegate should] receive:@selector(promise:didFailCommitment:)
                             withArguments:promise, promiseA];
            [promise failCommitment:promiseA];
        });
        
        it(@"should call the delegate when a promise is kept", ^{
            [[mockDelegate should] receive:@selector(promise:didKeepCommitment:)
                             withArguments:promise, promiseA];
            [[mockDelegate should] receive:@selector(promise:didKeepCommitment:)
                             withArguments:promise, promiseB];
            [[mockDelegate should] receive:@selector(promiseKept:)
                             withArguments:promise];
            [[mockDelegate should] receive:@selector(promiseDidResolve:)
                             withArguments:promise];
            [promise keepCommitment:promiseA];
            [promise keepCommitment:promiseB];
        });
        
        it(@"should call the delegate when a promise fails", ^{
            [[mockDelegate should] receive:@selector(promise:didFailCommitment:)
                             withArguments:promise, promiseA];
            [[mockDelegate should] receive:@selector(promise:didKeepCommitment:)
                             withArguments:promise, promiseB];
            [[mockDelegate should] receive:@selector(promiseDidFail:)
                             withArguments:promise];
            [[mockDelegate should] receive:@selector(promiseDidResolve:)
                             withArguments:promise];
            [promise failCommitment:promiseA];
            [promise keepCommitment:promiseB];
        });
    });
});

SPEC_END