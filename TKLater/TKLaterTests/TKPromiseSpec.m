//
//  TKLaterTests.h
//  TKLaterTests
//
//  Created by Tony Hillerson on 5/7/12.
//  Copyright (c) 2012 Tack Mobile, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "TKPromise.h"

SPEC_BEGIN(TKPromiseSpec)

describe(@"A Promise", ^{
    
    it(@"should exist", ^{
        id promiseClass = NSClassFromString(@"TKPromise");
        [[promiseClass should] beNonNil];
    });
    
    describe(@"with its informational API", ^{
    
        context(@"with two commitments to keep", ^{
            
            __block TKPromise *promise = nil;
            NSString *firstCommitment = @"first commitment";
            NSString *secondCommitment = @"second commitment";
        
            beforeEach(^{
                
                promise = [[TKPromise alloc] initWithPromiseKeptBlock:NULL
                                                   promiseFailedBlock:NULL
                                                 promiseResolvedBlock:NULL
                                                          commitments:firstCommitment, secondCommitment, nil];
            
            });
            
            it(@"should know that the promise is not kept yet", ^{
                
                BOOL promiseIsKept = [promise isKept];
                [[theValue(promiseIsKept) should] equal:theValue(NO)];
                
            });
            
            it(@"should know that the promise is not failed yet", ^{
                
                BOOL promiseIsFailed = [promise isFailed];
                [[theValue(promiseIsFailed) should] equal:theValue(NO)];
                
            });
            
            it(@"should know that the promise is not resolved yet", ^{
                
                BOOL promiseIsResolved = [promise isResolved];
                [[theValue(promiseIsResolved) should] equal:theValue(NO)];
                
            });
            
            it(@"should know if it's commited to a given commitment", ^{
                
                BOOL committedToFirstCommitment = [promise isCommittedTo:firstCommitment];
                [[theValue(committedToFirstCommitment) should] beYes];
                
            });
            
            context(@"and one commitment failed", ^{
                
                beforeEach(^{
                    [promise failCommitment:firstCommitment];
                });
                
                it(@"should know that the commitment has failed", ^{
                    BOOL isFailed = [promise isCommitmentFailed:firstCommitment];
                    [[theValue(isFailed) should] equal:theValue(YES)];
                    
                    isFailed = [promise isCommitmentFailed:secondCommitment];
                    [[theValue(isFailed) should] equal:theValue(NO)];
                    
                });
                
                it(@"should know that the promise has failed", ^{
                    BOOL isFailed = [promise isFailed];
                    [[theValue(isFailed) should] equal:theValue(YES)];
                    
                });
                
                it(@"should know how many commitments have failed", ^{
                    NSInteger commitmentsFailed = [promise countOfCommitmentsFailed];
                    [[theValue(commitmentsFailed) should] equal:theValue(1)];
                    
                    NSInteger commitmentsToKeep = [promise countOfCommitmentsToKeep];
                    [[theValue(commitmentsToKeep) should] equal:theValue(1)];
                });

            });
            
            context(@"and one commitment kept", ^{
                
                beforeEach(^{
                    [promise keepCommitment:firstCommitment];
                });
                
                it(@"should know that that commitment has been kept", ^{
                    BOOL firstCommitmentKept = [promise isCommitmentKept:firstCommitment];
                    [[theValue(firstCommitmentKept) should] beYes];

                    BOOL secondCommitmentKept = [promise isCommitmentKept:secondCommitment];
                    [[theValue(secondCommitmentKept) should] beNo];
                });
                
                it(@"should know how many commitments have been kept", ^{
                    NSInteger commitmentsKept = [promise countOfCommitmentsKept];
                    [[theValue(commitmentsKept) should] equal:theValue(1)];
                    
                    NSInteger commitmentsToKeep = [promise countOfCommitmentsToKeep];
                    [[theValue(commitmentsToKeep) should] equal:theValue(1)];
                });
                
            });
            
        });
    });

});

SPEC_END