//
//  IChatManagerGroupDelegate.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMGroupManagerDelegate.h"

@protocol IChatManagerGroupDelegate <EMGroupManagerDelegate>
@optional
- (void)group:(EMGroup *)group didCreateWithError:(EMError *)error;

- (void)didUpdateGroupList:(NSArray *)groupList
                     error:(EMError *)error;

- (void)group:(EMGroup *)group
     didLeave:(EMGroupLeaveReason)reason
        error:(EMError *)error;

- (void)groupDidUpdateInfo:(EMGroup *)group
                     error:(EMError *)error;


/*!
 @method
 @brief 同意入群申请后，同意者收到的回调
 @param groupId         申请加入的群组的ID
 @param username        申请加入的人的username
 @param error           错误信息
 */
- (void)didAcceptApplyJoinGroup:(NSString *)groupId
                       username:(NSString *)username
                          error:(EMError *)error;

/*!
 @method
 @brief 获取群组信息后的回调
 @param group 群组对象
 @param error 错误信息
 */
- (void)didFetchGroupInfo:(EMGroup *)group
                    error:(EMError *)error;

/*!
 @method
 @brief 获取群组成员列表后的回调
 @param occupantsList 群组成员列表（包含创建者）
 @param error         错误信息
 */
- (void)didFetchGroupOccupantsList:(NSArray *)occupantsList
                             error:(EMError *)error;

/*!
 @method
 @brief 获取群组黑名单列表后的回调
 @param groupId  群组id
 @param bansList 群组黑名单列表
 @param error         错误信息
 */
- (void)didFetchGroupBans:(NSString *)groupId
                     list:(NSArray *)bansList
                    error:(EMError *)error;

/*!
 @method
 @brief 加入公开群组后的回调
 @param group 群组对象
 @param error 错误信息
 */
- (void)didJoinPublicGroup:(EMGroup *)group
                     error:(EMError *)error;

/*!
 @method
 @brief 申请加入公开群组后的回调
 @param group 群组对象
 @param error 错误信息
 */
- (void)didApplyJoinPublicGroup:(EMGroup *)group
                          error:(EMError *)error;
@end
