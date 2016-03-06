//
//  IChatManagerChat.h
//  SDKChange
//
//  Created by WYZ on 16/3/5.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IChatManagerBase.h"
#import "EaseMobDefine.h"

@protocol IEMChatProgressDelegate;

@protocol IChatManagerChat <IChatManagerBase>

/*!
 @method
 @brief 发送一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @param pError   错误信息
 @result 发送完成后的消息对象
 */
- (EMMessage *)sendMessage:(EMMessage *)message
                  progress:(id<IEMChatProgressDelegate>)progress
                     error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");

/*!
 @method
 @brief 异步方法, 发送一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改. 在发送过程中, willSendMessage:error:和didSendMessage:error:这两个回调会被触发
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncSendMessage:(EMMessage *)message
                       progress:(id<IEMChatProgressDelegate>)sendProgress;

#pragma mark - message ack

/*!
 @method
 @brief 发送一个"已读消息"(在UI上显示了或者阅后即焚的销毁的时候发送)的回执到服务器
 @discussion
 @param message 从服务器收到的消息
 @result
 */
- (void)sendReadAckForMessage:(EMMessage *)message;

#pragma mark - resend message

/*!
 @method
 @brief 重新发送某一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @param pError   错误信息
 @result
 */
- (EMMessage *)resendMessage:(EMMessage *)message
                    progress:(id<IEMChatProgressDelegate>)progress
                       error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");

/*!
 @method
 @brief 异步方法, 重新发送某一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改. 在发送过程中, EMChatManagerChatDelegate中的willSendMessage:error:和didSendMessage:error:这两个回调会被触发
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncResendMessage:(EMMessage *)message
                         progress:(id<IEMChatProgressDelegate>)resendProgress;

@end
