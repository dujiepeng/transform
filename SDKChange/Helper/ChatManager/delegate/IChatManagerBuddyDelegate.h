//
//  IChatManagerBuddyDelegate.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IChatManagerBuddyDelegate <NSObject>

/*!
 @method
 @brief 获取好友列表成功时的回调
 @discussion
 @param buddyList 好友列表
 @param error     错误信息
 */
- (void)didFetchedBuddyList:(NSArray *)buddyList
                      error:(EMError *)error;

#pragma mark - block

/*!
 @method
 @brief 好友黑名单有更新时的回调
 @discussion
 @param blockedList 被加入黑名单的好友的列表
 */
- (void)didUpdateBlockedList:(NSArray *)blockedList;

/*!
 @method
 @brief 将好友加到黑名单完成后的回调
 @discussion
 @param username    加入黑名单的好友
 @param pError      错误信息
 */
- (void)didBlockBuddy:(NSString *)username error:(EMError *)pError;
@end
