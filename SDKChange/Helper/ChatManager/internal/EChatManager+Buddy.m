//
//  EChatManager+Buddy.m
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManager+Buddy.h"

@implementation EChatManager (Buddy)

@dynamic buddyList;
@dynamic blockedList;

#pragma mark - properties

- (NSArray *)buddyList
{
    return [[EMClient sharedClient].contactManager getContacts];
}

- (NSArray *)blockedList
{
    return [[EMClient sharedClient].contactManager getBlackList];
}
#pragma mark - fetch buddy from server
- (NSArray *)fetchBuddyListWithError:(EMError **)pError{
    EMError *error = nil;
    NSArray *ret = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (pError) {
        *pError = error;
    }
    
    return ret;
}

- (void)asyncFetchBuddyList{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *buddyList = [weakSelf fetchBuddyListWithError:&error];
        [_delegates didFetchedBuddyList:buddyList error:error];
    });
}

- (void)asyncFetchBuddyListWithCompletion:(void (^)(NSArray *buddyList, EMError *error))completion
                                    onQueue:(dispatch_queue_t)queue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *buddyList = [weakSelf fetchBuddyListWithError:&error];
        if (completion) {
            dispatch_queue_t blockQueue = dispatch_get_main_queue();
            if (queue) {
                blockQueue = queue;
            }
            dispatch_async(blockQueue, ^{
                completion(buddyList, error);
            });
        }
    });
}

#pragma mark - add buddy
- (BOOL)addBuddy:(NSString *)username
         message:(NSString *)message
           error:(EMError **)pError{
    EMError *error = [[EMClient sharedClient].contactManager addContact:username message:message];
    if (pError) {
        *pError = error;
    }
    
    if (error) {
        return NO;
    }
    
    return YES;
}

#pragma mark - remove buddy
- (BOOL)removeBuddy:(NSString *)username
   removeFromRemote:(BOOL)removeFromRemote
              error:(EMError **)pError{
    EMError *error = [[EMClient sharedClient].contactManager deleteContact:username];
    if (pError) {
        *pError = error;
    }
    
    if (error) {
        return NO;
    }
    
    return YES;
}

#pragma mark - accept buddy request
- (BOOL)acceptBuddyRequest:(NSString *)username
                     error:(EMError **)pError{
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:username];
    if (pError) {
        *pError = error;
    }
    
    if (error) {
        return NO;
    }
    
    return YES;
}

#pragma mark - reject buddy request
- (BOOL)rejectBuddyRequest:(NSString *)username
                    reason:(NSString *)reason
                     error:(EMError **)pError{
    EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:username];
    if (pError) {
        *pError = error;
    }
    
    if (error) {
        return NO;
    }
    
    return YES;
}

#pragma mark - fetch block
- (NSArray *)fetchBlockedList:(EMError **)pError{
    EMError *error = nil;
    NSArray *ret = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
    if (pError) {
        *pError = error;
    }
    
    return ret;
}

- (void)asyncFetchBlockedList{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *blockedList = [weakSelf fetchBlockedList:&error];
        [_delegates didUpdateBlockedList:blockedList];
    });
}

- (void)asyncFetchBlockedListWithCompletion:(void (^)(NSArray *blockedList, EMError *error))completion
                                    onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *blockedList = [weakSelf fetchBlockedList:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(blockedList, error);
            });
        }
    });
}

#pragma mark - block buddy
- (EMError *)blockBuddy:(NSString *)username
           relationship:(BOOL)relationship{
    return [[EMClient sharedClient].contactManager addUserToBlackList:username
                                                     relationshipBoth:relationship];
}


- (void)asyncBlockBuddy:(NSString *)username
           relationship:(BOOL)relationship{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [weakSelf blockBuddy:username relationship:relationship];
        [_delegates didBlockBuddy:username error:error];
    });
}


- (void)asyncBlockBuddy:(NSString *)username
           relationship:(BOOL)relationship
         withCompletion:(void (^)(NSString *username, EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [weakSelf blockBuddy:username relationship:relationship];
        if (completion) {
            dispatch_queue_t blockQueue = aQueue;
            if (!blockQueue) {
                blockQueue = dispatch_get_main_queue();
            }
            dispatch_async(blockQueue, ^{
                completion(username, error);
            });
        }
    });
}

#pragma mark - unblock buddy
- (EMError *)unblockBuddy:(NSString *)username{
    return [[EMClient sharedClient].contactManager removeUserFromBlackList:username];
}

- (void)asyncUnblockBuddy:(NSString *)username{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [weakSelf unblockBuddy:username];
        [_delegates didBlockBuddy:username error:error];
    });
}

- (void)asyncUnblockBuddy:(NSString *)username
           withCompletion:(void (^)(NSString *username, EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [weakSelf unblockBuddy:username];
        if (completion) {
            dispatch_queue_t blockQueue = aQueue;
            if (!blockQueue) {
                blockQueue = dispatch_get_main_queue();
            }
            dispatch_async(blockQueue, ^{
                completion(username, error);
            });
        }
    });
}

@end
