//
//  TKLaterTests.h
//  TKLaterTests
//
//  Created by Tony Hillerson on 5/7/12.
//  Copyright (c) 2012 Tack Mobile, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "TKPromise.h"

SPEC_BEGIN(TKPromiseErrorsSpec)

describe(@"A Promise", ^{

    __block TKPromise *promise = nil;
    NSString *promiseA = @"A";
    NSString *promiseB = @"B";
    
    context(@"with one commitment", ^{
        
        beforeEach(^{
            promise = [[TKPromise alloc] initWithPromiseKeptBlock:NULL
                                               promiseFailedBlock:NULL
                                             promiseResolvedBlock:NULL
                                                      commitments:promiseA, nil];
        });
        
        it(@"should throw an error if keeping a commitment that has already been kept", ^{
            [promise keepCommitment:promiseA];
            void(^secondKeep)() = ^{
                [promise keepCommitment:promiseA];
            };
            [[theBlock(secondKeep) should] raiseWithName:kTKPromiseCommitmentAlreadyKeptError
                                                  reason:[NSString stringWithFormat:@"Commitment '%@' has already been kept", promiseA]];
            
        });
        
        it(@"should throw an error if failing a commitment that has already been failed", ^{
            [promise failCommitment:promiseA];
            void(^secondFail)() = ^{
                [promise failCommitment:promiseA];
            };
            [[theBlock(secondFail) should] raiseWithName:kTKPromiseCommitmentAlreadyFailedError
                                                  reason:[NSString stringWithFormat:@"Commitment '%@' has already failed", promiseA]];
            
        });
        
        it(@"should throw an error if keeping a commitment that has already failed", ^{
            [promise failCommitment:promiseA];
            void(^keepAttempt)() = ^{
                [promise keepCommitment:promiseA];
            };
            [[theBlock(keepAttempt) should] raiseWithName:kTKPromiseCommitmentAlreadyFailedError
                                                  reason:[NSString stringWithFormat:@"Commitment '%@' has already failed", promiseA]];
            
        });
        
        it(@"should throw an error if failing a commitment that has already been kept", ^{
            [promise keepCommitment:promiseA];
            void(^failAttempt)() = ^{
                [promise failCommitment:promiseA];
            };
            [[theBlock(failAttempt) should] raiseWithName:kTKPromiseCommitmentAlreadyKeptError
                                                   reason:[NSString stringWithFormat:@"Commitment '%@' has already been kept", promiseA]];
            
        });
        
        it(@"should throw an error if attempting to keep a commitment it hasn't committed to", ^{
            void(^bogusKeepAttempt)() = ^{
                [promise keepCommitment:promiseB];
            };
            [[theBlock(bogusKeepAttempt) should] raiseWithName:kTKPromiseNoSuchCommitmentError
                                                   reason:[NSString stringWithFormat:@"Never committed to '%@'", promiseB]];
            
        });

        it(@"should throw an error if attempting to fail a commitment it hasn't committed to", ^{
            void(^bogusFailAttempt)() = ^{
                [promise failCommitment:promiseB];
            };
            [[theBlock(bogusFailAttempt) should] raiseWithName:kTKPromiseNoSuchCommitmentError
                                                        reason:[NSString stringWithFormat:@"Never committed to '%@'", promiseB]];
            
        });
        
    });
});

SPEC_END
