//
//  EChatManager+Buddy.m
//  SDKChange
//
//  Created by WYZ on 16/3/6.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import "EChatManager+Buddy.h"

@implementation EChatManager (Buddy)

- (NSArray *)buddyList
{
    return [[EMClient sharedClient].contactManager getContacts];
}

- (NSArray *)blockedList
{
    return [[EMClient sharedClient].contactManager getBlackList];
}

#pragma mark - fetch buddy from server

//手动获取好友列表,同步方法
- (NSArray *)fetchBuddyListWithError:(EMError **)pError
{
    EMError *error = nil;
    NSArray *ret = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (pError) {
        *pError = error;
    }
    if (error) {
        return nil;
    }
    return ret;
}

//手动获取好友列表(异步方法)
- (void)asyncFetchBuddyList
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *buddyList = [weakSelf fetchBuddyListWithError:&error];
        [_delegates didFetchedBuddyList:buddyList error:error];
    });
}

//手动获取好友列表(异步方法)
- (void)asyncFetchBuddyListWithCompletion:(void (^)(NSArray *buddyList, EMError *error))completion
                                    onQueue:(dispatch_queue_t)aQueue
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *budduList = [weakSelf fetchBuddyListWithError:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(budduList, error);
            });
        }
    });
}

#pragma mark - add buddy
//申请添加某个用户为好友
- (BOOL)addBuddy:(NSString *)username
         message:(NSString *)message
           error:(EMError **)pError
{
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

//将某个用户从好友列表中移除
- (BOOL)removeBuddy:(NSString *)username
              error:(EMError **)pError
{
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

//接受某个好友发送的好友请求
- (BOOL)acceptBuddyRequest:(NSString *)username
                     error:(EMError **)pError
{
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

/*!
 @method
 @brief 拒绝某个好友发送的好友请求
 @discussion
 @param username 需要拒绝的好友username
 @param pError   错误信息
 @result 是否拒绝成功
 */
- (BOOL)rejectBuddyRequest:(NSString *)username
                     error:(EMError *__autoreleasing *)pError
{
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

//获取黑名单（同步方法）
- (NSArray *)fetchBlockedList:(EMError **)pError
{
    EMError *error = nil;
    NSArray *blockedList = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
    if (pError) {
        *pError = error;
    }
    if (error) {
        return nil;
    }
    return blockedList;
}

//获取黑名单（异步方法）
- (void)asyncFetchBlockedList
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *blockedList = [weakSelf fetchBlockedList:&error];
        [_delegates didUpdateBlockedList:blockedList error:error];
    });
}

//获取黑名单（异步方法）
- (void)asyncFetchBlockedListWithCompletion:(void (^)(NSArray *blockedList, EMError *error))completion
                                    onQueue:(dispatch_queue_t)aQueue
{
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

//将username的用户加到黑名单（该用户不会被从好友中删除，若想删除，请自行调用删除接口）
- (EMError *)blockBuddy:(NSString *)username
           relationship:(BOOL)relationship
{
    return [[EMClient sharedClient].contactManager addUserToBlackList:username relationshipBoth:relationship];
}

//异步方法，将username的用户加到黑名单（该用户不会被从好友中删除，若想删除，请自行调用删除接口）
- (void)asyncBlockBuddy:(NSString *)username
           relationship:(BOOL)relationship
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [weakSelf blockBuddy:username relationship:relationship];
        [_delegates didBlockBuddy:username error:error];
    });
}

//异步方法，将username的用户加到黑名单（该用户不会被从好友中删除，若想删除，请自行调用删除接口）
- (void)asyncBlockBuddy:(NSString *)username
           relationship:(BOOL)relationship
         withCompletion:(void (^)(NSString *username, EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = [weakSelf blockBuddy:username relationship:relationship];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(username, error);
            });
        }
    });
}

#pragma mark - unblock buddy

//将username的用户移出黑名单
- (EMError *)unblockBuddy:(NSString *)username
{
    return [[EMClient sharedClient].contactManager removeUserFromBlackList:username];
}

//异步方法，将username的用户移出黑名单
- (void)asyncUnblockBuddy:(NSString *)username
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [weakSelf unblockBuddy:username];
        [_delegates didUnblockBuddy:username error:error];
    });
}

//异步方法，将username的用户移出黑名单
- (void)asyncUnblockBuddy:(NSString *)username
           withCompletion:(void (^)(NSString *username, EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = [weakSelf unblockBuddy:username];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(username, error);
            });
        }
    });

}

#pragma mark - DEPRECATED

//申请添加某个用户为好友,同时将该好友添加到分组中,好友与分组可以多对多
- (BOOL)addBuddy:(NSString *)username
         message:(NSString *)message
        toGroups:(NSArray *)groupNames
           error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete")
{
    return NO;
}

//将某个用户从好友列表中移除
- (BOOL)removeBuddy:(NSString *)username
   removeFromRemote:(BOOL)removeFromRemote
              error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Use -(BOOL)removeBuddy:error:")
{
    return NO;
}

//拒绝某个好友发送的好友请求
- (BOOL)rejectBuddyRequest:(NSString *)username
                    reason:(NSString *)reason
                     error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Use -(BOOL)rejectBuddyRequest:error:")
{
    return NO;
}

@end
