//
//  IChatManagerPushNotificationDelegate.h
//  SDKChange
//
//  Created by WYZ on 16/3/6.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @protocol
 @brief 本协议包括：更新推送设置后的回调
 @discussion
 */

@protocol IChatManagerPushNotificationDelegate <NSObject>

@optional
/*!
 @method
 @brief 更新全局推送设置后的回调
 @param options 更新后的全局推送设置
 @param error   错误信息
 */
- (void)didUpdatePushOptions:(EMPushOptions *)options
                       error:(EMError *)error;

/*!
 @method
 @brief 屏蔽/取消屏蔽 群推送消息后的回调
 @param ignoredGroupList 被屏蔽的群ID列表
 @param error            错误信息
 */
- (void)didIgnoreGroupPushNotification:(NSArray *)ignoredGroupList
                                 error:(EMError *)error;


@end
