//
//  EChatManager+Chat.m
//  SDKChange
//
//  Created by WYZ on 16/3/5.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import "EChatManager+Chat.h"
#import "IEMChatProgressDelegate.h"

@implementation EChatManager (Chat)

#pragma mark - send message

//发送一条消息
- (EMMessage *)sendMessage:(EMMessage *)message
                  progress:(id<IEMChatProgressDelegate>)progress
                     error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete")
{
    return nil;
}

//异步方法, 发送一条消息
- (EMMessage *)asyncSendMessage:(EMMessage *)message
                       progress:(id<IEMChatProgressDelegate>)sendProgress
{
    EMMessage *_message = [message mutableCopy];
    _message.status = EMMessageStatusPending;
    [_delegates willSendMessage:_message error:nil];
    __weak EMMessage *weakMesage = _message;
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        if (sendProgress) {
            weakMesage.status = EMMessageStatusDelivering;
            [sendProgress setProgress:progress forMessage:weakMesage forMessageBody:weakMesage.body];
        }
    } completion:^(EMMessage *message, EMError *error) {
        [_delegates didSendMessage:message error:error];
    }];
    return message;
}

#pragma mark - message ack

//发送一个"已读消息"
- (void)sendReadAckForMessage:(EMMessage *)message
{
    [[EMClient sharedClient].chatManager asyncSendReadAckForMessage:message];
}

#pragma mark - resend message

//重新发送某一条消息
- (EMMessage *)resendMessage:(EMMessage *)message
                    progress:(id<IEMChatProgressDelegate>)progress
                       error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete")
{
    return message;
}

//异步方法, 重新发送某一条消息
- (EMMessage *)asyncResendMessage:(EMMessage *)message
                         progress:(id<IEMChatProgressDelegate>)resendProgress
{
    EMMessage *_message = [message mutableCopy];
    _message.status = EMMessageStatusPending;
    [_delegates willSendMessage:message error:nil];
    __weak EMMessage *weakMesage = _message;
    [[EMClient sharedClient].chatManager asyncResendMessage:message progress:^(int progress) {
        if (resendProgress) {
            weakMesage.status = EMMessageStatusDelivering;
            [resendProgress setProgress:progress forMessage:weakMesage forMessageBody:weakMesage.body];
        }
    } completion:^(EMMessage *message, EMError *error) {
        [_delegates didSendMessage:message error:error];
    }];
    return message;
}

@end
