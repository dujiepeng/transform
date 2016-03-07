//
//  IChatManagerBuddyDelegate.h
//  SDKChange
//
//  Created by WYZ on 16/3/6.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMContactManagerDelegate.h"

@protocol IChatManagerBuddyDelegate <EMContactManagerDelegate>

@optional

/*!
 @method
 @brief 获取好友列表成功时的回调
 @discussion
 @param buddyList 好友列表
 @param error     错误信息
 */
- (void)didFetchedBuddyList:(NSArray *)groupList
                      error:(EMError *)error;

/*!
 @method
 @brief 好友黑名单有更新时的回调
 @discussion
 @param blockedList 被加入黑名单的好友的列表
 @param error 错误信息
 */
- (void)didUpdateBlockedList:(NSArray *)blockedList error:(EMError *)error;

/*!
 @method
 @brief 将好友加到黑名单完成后的回调
 @discussion
 @param username    加入黑名单的好友
 @param pError      错误信息
 */
- (void)didBlockBuddy:(NSString *)username error:(EMError *)pError;

/*!
 @method
 @brief 将好友移出黑名单完成后的回调
 @discussion
 @param username    移出黑名单的好友
 @param pError      错误信息
 */
- (void)didUnblockBuddy:(NSString *)username error:(EMError *)pError;


@end
