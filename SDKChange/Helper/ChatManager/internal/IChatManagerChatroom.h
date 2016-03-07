//
//  IChatManagerChatroom.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IChatManagerBase.h"

@protocol IChatManagerChatroom <IChatManagerBase>

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

/*!
 @method
 @brief 异步方法, 加入一个聊天室
 @param chatroomId  聊天室的ID
 @param completion  加入聊天室完成后的回调, 回调会在主线程调用
 */
- (void)asyncJoinChatroom:(NSString *)chatroomId
               completion:(void (^)(EMChatroom *chatroom,
                                    EMError *error))completion;
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
                        error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 退出聊天室
 @param chatroomId  聊天室ID
 @param completion  退出聊天室完成后的回调, 回调会在主线程调用
 */
- (void)asyncLeaveChatroom:(NSString *)chatroomId
                completion:(void (^)(EMChatroom *chatroom, EMError *error))completion;
@end
