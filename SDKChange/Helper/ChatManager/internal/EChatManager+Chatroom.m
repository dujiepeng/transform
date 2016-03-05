//
//  EChatManager+Chatroom.m
//  SDKChange
//
//  Created by WYZ on 16/3/5.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import "EChatManager+Chatroom.h"
#import "EMSDK.h"

@implementation EChatManager (Chatroom)

#pragma mark - fetch all chatrooms

/*!
 @method
 @brief 同步方法，从服务器获取所有的聊天室
 @param pError   出错信息
 @return         聊天室列表<EMChatroom>
 @discussion
 这是一个阻塞方法，用户应当在一个独立线程中执行此方法
 */
- (NSArray<EMChatroom *> *)fetchChatroomsFromServerWithError:(EMError **)pError
{
    EMError *error = nil;
    NSArray *chatrooms = [[EMClient sharedClient].roomManager getAllChatroomsFromServerWithError:&error];
    if (pError) {
        *pError = error;
    }
    if (error) {
        return nil;
    }
    return chatrooms;
}

/*!
 @method
 @brief 异步方法, 从服务器获取所有的聊天室
 @param completion  完成回调，回调会在主线程调用
 */
- (void)asyncFetchChatroomsFromServer:(void (^)(NSArray<EMChatroom *> *chatroom, EMError *error))completion
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray<EMChatroom *> *chatrooms = [weakSelf fetchChatroomsFromServerWithError:&error];
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion (chatrooms, error);
            });
        }
    });
}


/*!
 @method
 @brief 获取指定范围内的聊天室
 @param cursor   获取聊天室的cursor，首次调用传空即可
 @param pageSize 期望结果的数量, 如果 < 0 则一次返回所有结果
 @param pError   出错信息
 @return         获取的聊天室结果
 @discussion
 这是一个阻塞方法，用户应当在一个独立线程中执行此方法，用户可以连续调用此方法以获得所有聊天室
 */
- (EMCursorResult *)fetchChatroomsFromServerWithCursor:(NSString *)cursor
                                              pageSize:(NSInteger)pageSize
                                              andError:(EMError **)pError EM_DEPRECATED_IOS(2_1_7, 2_2_2, "Delete")
{
    return nil;
}

/*!
 @method
 @brief 异步方法, 获取指定范围的聊天室
 @param cursor      获取聊天室的cursor，首次调用传空即可
 @param pageSize    期望结果的数量, 如果 < 0 则一次返回所有结果
 @param completion  完成回调，回调会在主线程调用
 */
- (void)asyncFetchChatroomsFromServerWithCursor:(NSString *)cursor
                                       pageSize:(NSInteger)pageSize
                                  andCompletion:(void (^)(EMCursorResult *result, EMError *error))completion EM_DEPRECATED_IOS(2_1_7, 2_2_2, "Delete")
{
}

#pragma mark - fetch chatroom info

/*!
 @method
 @brief 同步方法, 获取聊天室信息
 @param chatroomId  聊天室ID
 @param pError      错误信息
 @return 聊天室
 */
- (EMChatroom *)fetchChatroomInfo:(NSString *)chatroomId
                            error:(EMError **)pError
{
    EMError *error = nil;
    NSArray *chatrooms = [self fetchChatroomsFromServerWithError:&error];
    if (pError) {
        *pError = error;
    }
    if (error || !chatrooms) {
        return nil;
    }
    __block EMChatroom *chatroom = nil;
    [chatrooms enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[EMChatroom class]])
        {
            EMChatroom *currentChatRoom = (EMChatroom *)obj;
            if ([currentChatRoom.chatroomId isEqualToString:chatroomId])
            {
                chatroom = [currentChatRoom mutableCopy];
                *stop = YES;
            }
        }
    }];
    return chatroom;
}

/*!
 @method
 @brief 异步方法, 获取聊天室信息
 @param chatroomId  群组ID
 @param completion  完成后的回调, 回调会在主线程调用
 */
- (void)asyncFetchChatroomInfo:(NSString *)chatroomId
                    completion:(void (^)(EMChatroom *chatroom, EMError *error))completion
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMChatroom *chatroom = [weakSelf fetchChatroomInfo:chatroomId error:&error];
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(chatroom, error);
            });
        }
    });
}

#pragma mark - fetch chatroom occupants

/*!
 @method
 @brief 同步方法, 获取聊天室成员
 @param chatroomId  聊天室ID
 @param cursor      获取成员的cursor，首次调用传空即可
 @param pageSize    期望结果的数量
 @param pError      错误信息
 @return  获取的成员结果
 */
- (EMCursorResult *)fetchOccupantsForChatroom:(NSString *)chatroomId
                                       cursor:(NSString *)cursor
                                     pageSize:(NSInteger)pageSize
                                     andError:(EMError **)pError EM_DEPRECATED_IOS(2_1_7, 2_2_2, "Delete")
{
    return nil;
}

/*!
 @method
 @brief 同步方法, 获取聊天室成员列表
 @param chatroomId  聊天室ID
 @param cursor      获取成员的cursor，首次调用传空即可
 @param pageSize    期望结果的数量
 @param completion 完成后的回调
 */
- (void)asyncFetchOccupantsForChatroom:(NSString *)chatroomId
                                cursor:(NSString *)cursor
                              pageSize:(NSInteger)pageSize
                            completion:(void (^)(EMCursorResult *result, EMError *error))completion EM_DEPRECATED_IOS(2_1_7, 2_2_2, "Delete")
{
}

#pragma mark - join/leave chatroom

/*!
 @method
 @brief 加入一个聊天室
 @param chatroomId  聊天室的ID
 @param pError      错误信息
 @result 所加入的聊天室
 @discussion
 这是一个阻塞方法，用户应当在一个独立线程中执行此方法
 */
- (EMChatroom *)joinChatroom:(NSString *)chatroomId
                       error:(EMError **)pError;
{
    EMError *error = nil;
    EMChatroom *chatroom = [[EMClient sharedClient].roomManager joinChatroom:chatroomId error:&error];
    if (pError) {
        *pError = error;
    }
    if (error) {
        return nil;
    }
    return chatroom;
}

/*!
 @method
 @brief 异步方法, 加入一个聊天室
 @param chatroomId  聊天室的ID
 @param completion  加入聊天室完成后的回调, 回调会在主线程调用
 */
- (void)asyncJoinChatroom:(NSString *)chatroomId
               completion:(void (^)(EMChatroom *chatroom, EMError *error))completion
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMChatroom *chatroom = [weakSelf joinChatroom:chatroomId error:&error];
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(chatroom, error);
            });
        }
    });
}

/*!
 @method
 @brief 退出聊天室
 @param chatroomId  聊天室ID
 @param pError      错误信息
 @result 退出的聊天室, 失败返回nil
 @discussion
 这是一个阻塞方法，用户应当在一个独立线程中执行此方法
 */
- (EMChatroom *)leaveChatroom:(NSString *)chatroomId
                        error:(EMError **)pError
{
    EMError *error = nil;
    EMChatroom *chatroom = [[EMClient sharedClient].roomManager leaveChatroom:chatroomId error:&error];
    if (pError) {
        *pError = error;
    }if (error) {
        return nil;
    }
    return chatroom;
}

/*!
 @method
 @brief 异步方法, 退出聊天室
 @param chatroomId  聊天室ID
 @param completion  退出聊天室完成后的回调, 回调会在主线程调用
 */
- (void)asyncLeaveChatroom:(NSString *)chatroomId
                completion:(void (^)(EMChatroom *chatroom, EMError *error))completion
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMChatroom *chatroom = [weakSelf leaveChatroom:chatroomId error:&error];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(chatroom, error);
            });
        }
    });
}


@end
