//
//  TKLater.h
//  TKLater
//
//  Created by Tony Hillerson on 5/7/12.
//  Copyright (c) 2012 Tack Mobile, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

typedef void (^TKPromiseKeptBlock)();
typedef void (^TKPromiseFailedBlock)();
typedef void (^TKPromiseResolveBlock)();

#define kTKPromiseCommitmentAlreadyKeptError @"kTKPromiseCommitmentAlreadyKeptError"
#define kTKPromiseCommitmentAlreadyFailedError @"kTKPromiseCommitmentAlreadyFailedError"
#define kTKPromiseNoSuchCommitmentError @"kTKPromiseNoSuchCommitmentError"
#define kTKPromiseAlreadyResolvedError @"kTKPromiseAlreadyResolvedError"

@class TKPromise;

@protocol TKPromiseDelegate <NSObject>
@optional
- (void) promise:(TKPromise *)promise didKeepCommittment:(NSString *)committment;
- (void) promise:(TKPromise *)promise didFailCommittment:(NSString *)committment;
- (void) promiseKept:(TKPromise *)promise;
- (void) promiseDidFail:(TKPromise *)promise;
- (void) promiseDidResolve:(TKPromise *)promise;
@end

@interface TKPromise : NSObject {
    TKPromiseKeptBlock promiseKeptBlock;
    TKPromiseFailedBlock promiseFailedBlock;
    TKPromiseResolveBlock resolveBlock;
    NSMutableSet *commitments;
    NSMutableSet *keptCommitments;
    NSMutableSet *failedCommitments;
}

- (id) initWithPromiseKeptBlock:(TKPromiseKeptBlock)promiseKeptBlock
             promiseFailedBlock:(TKPromiseFailedBlock)promiseFailedBlock
           promiseResolvedBlock:(TKPromiseResolveBlock)resolveBlock
                    commitments:(NSString *)aCommitment, ... NS_REQUIRES_NIL_TERMINATION;

@property(nonatomic) id<TKPromiseDelegate> delegate;

- (BOOL) isCommittedTo:(NSString *)commitment;
- (BOOL) isCommitmentKept:(NSString *)commitment;
- (BOOL) isCommitmentFailed:(NSString *)commitment;
- (BOOL) isKept;
- (BOOL) isFailed;
- (BOOL) isResolved;
- (NSInteger) countOfCommitmentsKept;
- (NSInteger) countOfCommitmentsFailed;
- (NSInteger) countOfCommitmentsToKeep;
- (void) keepCommitment:(NSString *)commitment;
- (void) failCommitment:(NSString *)commitment;
- (void) addCommitment:(NSString *)commitment;
- (void) addCommitments:(NSSet *)commitments;

@end

