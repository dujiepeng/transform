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

//同步方法，从服务器获取所有的聊天室
- (NSArray<EMChatroom *> *)fetchChatroomsFromServerWithError:(EMError **)pError
{
    EMError *error = nil;
    NSArray *chatrooms = [[EMClient sharedClient].roomManager getAllChatroomsFromServerWithError:&error];
    if (pError) {
        *pError = error;
    }

    return chatrooms;
}

//异步方法, 从服务器获取所有的聊天室
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

//获取指定范围内的聊天室
- (EMCursorResult *)fetchChatroomsFromServerWithCursor:(NSString *)cursor
                                              pageSize:(NSInteger)pageSize
                                              andError:(EMError **)pError EM_DEPRECATED_IOS(2_1_7, 2_2_2, "Delete")
{
    return nil;
}

//异步方法, 获取指定范围的聊天室
- (void)asyncFetchChatroomsFromServerWithCursor:(NSString *)cursor
                                       pageSize:(NSInteger)pageSize
                                  andCompletion:(void (^)(EMCursorResult *result, EMError *error))completion EM_DEPRECATED_IOS(2_1_7, 2_2_2, "Delete")
{
}

#pragma mark - fetch chatroom info

//同步方法, 获取聊天室信息
- (EMChatroom *)fetchChatroomInfo:(NSString *)chatroomId
                            error:(EMError **)pError
{
    if (!chatroomId) {
        if (pError) {
            *pError = [[EMError alloc] initWithDescription:@"群组id无效" code:EMErrorGroupInvalidId];
        }
        return nil;
    }
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

//异步方法, 获取聊天室信息
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

//同步方法, 获取聊天室成员
- (EMCursorResult *)fetchOccupantsForChatroom:(NSString *)chatroomId
                                       cursor:(NSString *)cursor
                                     pageSize:(NSInteger)pageSize
                                     andError:(EMError **)pError EM_DEPRECATED_IOS(2_1_7, 2_2_2, "Delete")
{
    return nil;
}

//同步方法, 获取聊天室成员列表
- (void)asyncFetchOccupantsForChatroom:(NSString *)chatroomId
                                cursor:(NSString *)cursor
                              pageSize:(NSInteger)pageSize
                            completion:(void (^)(EMCursorResult *result, EMError *error))completion EM_DEPRECATED_IOS(2_1_7, 2_2_2, "Delete")
{
}

#pragma mark - join/leave chatroom

//加入一个聊天室
- (EMChatroom *)joinChatroom:(NSString *)chatroomId
                       error:(EMError **)pError;
{
    if (!chatroomId) {
        if (pError) {
            *pError = [[EMError alloc] initWithDescription:@"群组id无效" code:EMErrorGroupInvalidId];
        }
        return nil;
    }
    EMError *error = nil;
    EMChatroom *chatroom = [[EMClient sharedClient].roomManager joinChatroom:chatroomId error:&error];
    if (pError) {
        *pError = error;
    }

    return chatroom;
}

//异步方法, 加入一个聊天室
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


//退出聊天室
- (EMChatroom *)leaveChatroom:(NSString *)chatroomId
                        error:(EMError **)pError
{
    if (!chatroomId) {
        if (pError) {
            *pError = [[EMError alloc] initWithDescription:@"群组id无效" code:EMErrorGroupInvalidId];
        }
        return nil;
    }
    EMError *error = nil;
    EMChatroom *chatroom = [[EMClient sharedClient].roomManager leaveChatroom:chatroomId error:&error];
    if (pError) {
        *pError = error;
    }
    
    return chatroom;
}

//异步方法, 退出聊天室
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
