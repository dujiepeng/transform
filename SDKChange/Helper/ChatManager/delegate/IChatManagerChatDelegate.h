//
//  IChatManagerChatDelegate.h
//  SDKChange
//
//  Created by WYZ on 16/3/5.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMChatManagerDelegate.h"
#import "EaseMobDefine.h"

@protocol IChatManagerChatDelegate <EMChatManagerDelegate>

@optional

/*!
 @method
 @brief 将要发送消息时的回调
 @discussion
 @param message      将要发送的消息对象
 @param error        错误信息
 @result
 */
- (void)willSendMessage:(EMMessage *)message
                  error:(EMError *)error;

/*!
 @method
 @brief 发送消息后的回调
 @discussion
 @param message      已发送的消息对象
 @param error        错误信息
 @result
 */
- (void)didSendMessage:(EMMessage *)message
                 error:(EMError *)error;

@end
