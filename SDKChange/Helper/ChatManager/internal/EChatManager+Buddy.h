//
//  EChatManager+Buddy.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManagerBase.h"
#import "IChatManagerBuddy.h"
@interface EChatManager (Buddy)<IChatManagerBuddy>

@property (nonatomic, strong, readonly) NSArray *buddyList;
@property (nonatomic, strong, readonly) NSArray *blockedList;

#pragma mark - fetch buddy from server
- (NSArray *)fetchBuddyListWithError:(EMError **)pError;

- (void)asyncFetchBuddyList;

- (void)asyncFetchBuddyListWithCompletion:(void (^)(NSArray *buddyList, EMError *error))completion
                                    onQueue:(dispatch_queue_t)queue;

#pragma mark - add buddy
- (BOOL)addBuddy:(NSString *)username
         message:(NSString *)message
           error:(EMError **)pError;

#pragma mark - remove buddy
- (BOOL)removeBuddy:(NSString *)username
   removeFromRemote:(BOOL)removeFromRemote
              error:(EMError **)pError;

#pragma mark - accept buddy request
- (BOOL)acceptBuddyRequest:(NSString *)username
                     error:(EMError **)pError;

#pragma mark - reject buddy request
- (BOOL)rejectBuddyRequest:(NSString *)username
                    reason:(NSString *)reason
                     error:(EMError **)pError;

#pragma mark - fetch block
- (NSArray *)fetchBlockedList:(EMError **)pError;

- (void)asyncFetchBlockedList;

- (void)asyncFetchBlockedListWithCompletion:(void (^)(NSArray *blockedList, EMError *error))completion
                                    onQueue:(dispatch_queue_t)aQueue;

#pragma mark - block buddy
- (EMError *)blockBuddy:(NSString *)username
           relationship:(BOOL)relationship;


- (void)asyncBlockBuddy:(NSString *)username
           relationship:(BOOL)relationship;


- (void)asyncBlockBuddy:(NSString *)username
           relationship:(BOOL)relationship
         withCompletion:(void (^)(NSString *username, EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue;

#pragma mark - unblock buddy
- (EMError *)unblockBuddy:(NSString *)username;

- (void)asyncUnblockBuddy:(NSString *)username;

- (void)asyncUnblockBuddy:(NSString *)username
           withCompletion:(void (^)(NSString *username, EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue;
@end
