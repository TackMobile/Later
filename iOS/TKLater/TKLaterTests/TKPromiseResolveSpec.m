//
//  TKLaterTests.h
//  TKLaterTests
//
//  Created by Tony Hillerson on 5/10/12.
//  Copyright (c) 2012 Tack Mobile, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "TKPromise.h"

SPEC_BEGIN(TKPromiseResolveSpec)

describe(@"A Promise", ^{
    
    __block TKPromise *promise = nil;
    __block NSString *resolveResults = nil;
    __block NSString *promiseResults = nil;
    NSString *promiseA = @"A";
    NSString *promiseB = @"B";
    
    context(@"with a resolve block", ^{
        
        beforeEach(^{
            resolveResults = nil;
            promiseResults = nil;
            
            TKPromiseKeptBlock promiseKeptBlock = ^{
                promiseResults = @"kept";
            };
            
            TKPromiseFailedBlock promiseFailedBlock = ^{
                promiseResults = @"failed";
            };
            
            TKPromiseResolveBlock resolveBlock = ^{
                resolveResults = @"resolved";
            };
            
            promise = [[TKPromise alloc] initWithPromiseKeptBlock:promiseKeptBlock
                                               promiseFailedBlock:promiseFailedBlock
                                             promiseResolvedBlock:resolveBlock
                                                      commitments:promiseA, promiseB, nil];
        });
        
        it(@"should execute the resolve block when kept", ^{
            [promise keepCommitment:promiseA];
            [promise keepCommitment:promiseB];
            [[promiseResults should] equal:@"kept"];
            [[resolveResults should] equal:@"resolved"];
            BOOL isResolved = [promise isResolved];
            [[theValue(isResolved) should] beYes];
        });
        
        it(@"should execute the resolve block when failed", ^{
            [promise failCommitment:promiseA];
            [promise failCommitment:promiseB];
            [[promiseResults should] equal:@"failed"];
            [[resolveResults should] equal:@"resolved"];
            BOOL isResolved = [promise isResolved];
            [[theValue(isResolved) should] beYes];
        });
        
        it(@"should execute the resolve block when partially kept and complete", ^{
            [promise failCommitment:promiseB];
            [promise keepCommitment:promiseA];
            [[promiseResults should] equal:@"failed"];
            [[resolveResults should] equal:@"resolved"];
            BOOL isResolved = [promise isResolved];
            [[theValue(isResolved) should] beYes];
        });

    });
});

SPEC_END