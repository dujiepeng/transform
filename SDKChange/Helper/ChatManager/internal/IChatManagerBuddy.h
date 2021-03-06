//
//  IChatManagerBuddy.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IChatManagerBase.h"
#import "EMSDK.h"

@protocol IChatManagerBuddy <IChatManagerBase>
/*!
 @property
 @brief 好友列表(由EMBuddy对象组成)
 */
@property (nonatomic, strong, readonly) NSArray *buddyList;

/*!
 @property
 @brief 好友黑名单列表(由EMBuddy对象组成)
 */
@property (nonatomic, strong, readonly) NSArray *blockedList;

#pragma mark - fetch buddy from server

/*!
 @method
 @brief 手动获取好友列表
 @discussion
 @result 好友列表
 */
- (NSArray *)fetchBuddyListWithError:(EMError **)pError;

/*!
 @method
 @brief 手动获取好友列表(异步方法)
 @discussion 好友列表获取完成时, 会调用 didFetchedBuddyList:error(EMChatManagerBuddyDelegate.h 中) 回调方法
 */
- (void *)asyncFetchBuddyList;

/*!
 @method
 @brief 手动获取好友列表(异步方法)
 @discussion
 @param completion 获取好友列表完成后的回调
 @param queue      completion block 回调时的线程
 */
- (void *)asyncFetchBuddyListWithCompletion:(void (^)(NSArray *buddyList, EMError *error))completion
                                    onQueue:(dispatch_queue_t)queue;

#pragma mark - add buddy

/*!
 @method
 @brief 申请添加某个用户为好友
 @discussion
 @param username 需要添加为好友的username
 @param message  申请添加好友时的附带信息
 @param pError   错误信息
 @result 好友申请是否发送成功
 */
- (BOOL)addBuddy:(NSString *)username
         message:(NSString *)message
           error:(EMError **)pError;

#pragma mark - remove buddy

/*!
 @method
 @brief 将某个用户从好友列表中移除
 @discussion
 @param username 需要移除的好友username
 @param removeFromRemote 是否将自己从对方好友列表中移除
 @param pError   错误信息
 @result 是否移除成功
 */
- (BOOL)removeBuddy:(NSString *)username
   removeFromRemote:(BOOL)removeFromRemote
              error:(EMError **)pError;

#pragma mark - accept buddy request

/*!
 @method
 @brief 接受某个好友发送的好友请求
 @discussion
 @param username 需要接受的好友username
 @param pError   错误信息
 @result 是否接受成功
 */
- (BOOL)acceptBuddyRequest:(NSString *)username
                     error:(EMError **)pError;

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
                    reason:(NSString *)reason
                     error:(EMError **)pError;

#pragma mark - fetch block

/*!
 @method
 @brief 获取黑名单（同步方法）
 @discussion
 @param pError 错误信息
 @result 黑名单（username）
 */
- (NSArray *)fetchBlockedList:(EMError **)pError;

/*!
 @method
 @brief 获取黑名单（异步方法）
 @discussion
 函数执行完, 回调[didUpdateBlockedList:]会被触发
 */
- (void)asyncFetchBlockedList;

/*!
 @method
 @brief 获取黑名单（异步方法）
 @param completion     创建完成后的回调
 @param aQueue         回调block时的线程
 @discussion
 获取黑名单成功 判断条件：completion中，error == nil
 函数执行完, 会调用参数completion
 */
- (void)asyncFetchBlockedListWithCompletion:(void (^)(NSArray *blockedList, EMError *error))completion
                                    onQueue:(dispatch_queue_t)aQueue;

#pragma mark - block buddy

/*!
 @method
 @brief 将username的用户加到黑名单（该用户不会被从好友中删除，若想删除，请自行调用删除接口）
 @discussion
 @param username        加入黑名单的用户username
 @param relationship    黑名单关系（both:双向都不接受消息；
 from:能给黑名单中的人发消息，接收不到黑名单中的人发的消息;
 to:暂不支持）
 @result 是否成功的向服务器发送了block信息（不包含 服务器是否成功将用户加入黑名单）
 */
- (EMError *)blockBuddy:(NSString *)username
           relationship:(BOOL)relationship;

/*!
 @method
 @brief 异步方法，将username的用户加到黑名单（该用户不会被从好友中删除，若想删除，请自行调用删除接口）
 @param username        加入黑名单的用户username
 @param relationship    黑名单关系（both:双向都不接受消息；
 from:能给黑名单中的人发消息，接收不到黑名单中的人发的消息;
 to:暂不支持）
 @discussion
 函数执行完, 回调[didBlockBuddy:error:]会被触发
 */
- (void)asyncBlockBuddy:(NSString *)username
           relationship:(BOOL)relationship;

/*!
 @method
 @brief 异步方法，将username的用户加到黑名单（该用户不会被从好友中删除，若想删除，请自行调用删除接口）
 @param username       加入黑名单的用户username
 @param relationship   黑名单关系（both:双向都不接受消息；
 from:能给黑名单中的人发消息，接收不到黑名单中的人发的消息;
 to:暂不支持）
 @param completion     完成后的回调
 @param aQueue         回调block时的线程
 @discussion
 加黑名单成功 判断条件：completion中，error == nil 函数执行完, 会调用参数completion
 */
- (void)asyncBlockBuddy:(NSString *)username
           relationship:(BOOL)relationship
         withCompletion:(void (^)(NSString *username, EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue;

#pragma mark - unblock buddy

/*!
 @method
 @brief 将username的用户移出黑名单
 @discussion
 @param username 移出黑名单的用户username
 @result 是否成功的向服务器发送了unblock信息（不包含 服务器是否成功将用户移出黑名单）
 */
- (EMError *)unblockBuddy:(NSString *)username;

/*!
 @method
 @brief 异步方法，将username的用户移出黑名单
 @param username        加入黑名单的用户username
 @discussion
 函数执行完, 回调[didUnblockBuddy:error:]会被触发
 */
- (void)asyncUnblockBuddy:(NSString *)username;

/*!
 @method
 @brief 异步方法，将username的用户移出黑名单
 @param username       加入黑名单的用户username
 @param completion     完成后的回调
 @param aQueue         回调block时的线程
 @discussion
 移出黑名单成功 判断条件：completion中，error == nil 函数执行完, 会调用参数completion
 */
- (void)asyncUnblockBuddy:(NSString *)username
           withCompletion:(void (^)(NSString *username, EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue;
@end
