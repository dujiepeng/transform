//
//  EChatManager+Util.m
//  SDKChange
//
//  Created by WYZ on 16/3/6.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import "EChatManager+Util.h"
#import "IEMChatProgressDelegate.h"

@implementation EChatManager (Util)


#pragma mark - fetch message

//获取聊天对象对应的远程服务器上的文件, 同步方法
- (EMMessage *)fetchMessage:(EMMessage *)aMessage
                   progress:(id<IEMChatProgressDelegate>)progress
                      error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete")
{
    return nil;
}

//获取聊天对象对应的远程服务器上的文件, 异步方法
- (void)asyncFetchMessage:(EMMessage *)aMessage
                 progress:(id<IEMChatProgressDelegate>)progress
{
    [[EMClient sharedClient].chatManager asyncDownloadMessageAttachments:aMessage progress:^(int aProgress) {
        if (progress) {
            [progress setProgress:Progress(aProgress) forMessage:aMessage forMessageBody:aMessage.body];
        }
    } completion:^(EMMessage *message, EMError *error) {
        [_delegates didMessageAttachmentsStatusChanged:message error:error];
    }];
}

//获取聊天对象对应的远程服务器上的文件, 异步方法
- (void)asyncFetchMessage:(EMMessage *)aMessage
                 progress:(id<IEMChatProgressDelegate>)progress
               completion:(void (^)(EMMessage *aMessage,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue
{
    [[EMClient sharedClient].chatManager asyncDownloadMessageAttachments:aMessage progress:^(int aProgress) {
        if (progress) {
            [progress setProgress:Progress(aProgress) forMessage:aMessage forMessageBody:aMessage.body];
        }
    } completion:^(EMMessage *message, EMError *error) {
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(aMessage, error);
            });
        }
    }];
}
#pragma mark - fetch message thumbnail

//获取聊天对象的缩略图, 同步方法
- (EMMessage *)fetchMessageThumbnail:(EMMessage *)aMessage
                            progress:(id<IEMChatProgressDelegate>)progress
                               error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete")
{
    return nil;
}

//获取聊天对象的缩略图,异步方法
- (void)asyncFetchMessageThumbnail:(EMMessage *)aMessage
                          progress:(id<IEMChatProgressDelegate>)progress
{
    [[EMClient sharedClient].chatManager asyncDownloadMessageThumbnail:aMessage progress:^(int aProgress) {
        if (progress) {
            [progress setProgress:Progress(aProgress) forMessage:aMessage forMessageBody:aMessage.body];
        }
    } completion:^(EMMessage *message, EMError *error) {
        [_delegates didMessageThumbnaiStatusChanged:message error:error];
    }];
}

//获取聊天对象的缩略图,异步方法
- (void)asyncFetchMessageThumbnail:(EMMessage *)aMessage
                          progress:(id<IEMChatProgressDelegate>)progress
                        completion:(void (^)(EMMessage * aMessage,
                                             EMError *error))completion
                           onQueue:(dispatch_queue_t)aQueue
{
    [[EMClient sharedClient].chatManager asyncDownloadMessageThumbnail:aMessage progress:^(int aProgress) {
        if (progress) {
            [progress setProgress:Progress(aProgress) forMessage:aMessage forMessageBody:aMessage.body];
        }
    } completion:^(EMMessage *message, EMError *error) {
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(aMessage, error);
            });
        }
    }];
}
@end
