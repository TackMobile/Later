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
    
    context(@"with a list of commitments to keep", ^{
        
        __block TKPromise *promise = nil;
        NSString *firstCommitment = @"first commitment";
        NSString *secondCommitment = @"second commitment";
    
        beforeEach(^{
            
            promise = [[TKPromise alloc] initWithCommitments:firstCommitment, secondCommitment, nil];
        
        });
        
        it(@"should know if it's commited to a given commitment", ^{
            
            BOOL committedToFirstCommitment = [promise isCommittedTo:firstCommitment];
            [[theValue(committedToFirstCommitment) should] beYes];
            
        });
        
        context(@"and one commitment kept", ^{
            
            beforeEach(^{
                [promise keepCommitment:firstCommitment];
            });
            
            it(@"should know that those commitments have been kept", ^{
                BOOL firstCommitmentKept = [promise isCommitmentKept:firstCommitment];
                [[theValue(firstCommitmentKept) should] beYes];
            });
        
        });
    
    });

});

SPEC_END