//
//  EChatManager+Group.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManagerBase.h"
#import "EMGroupManagerDelegate.h"
#import "IChatManagerGroup.h"
#import "EaseMobDefine.h"

@interface EChatManager (Group) <IChatManagerGroup>

#pragma mark - delegate
@property (nonatomic, strong, readonly) NSArray *groupList;

- (NSArray *)loadAllMyGroupsFromDatabaseWithAppend2Chat:(BOOL)append2Chat;

#pragma mark - create group

/*!
 @method
 @brief 创建群组（同步方法）
 @param aSubject        群组名称
 @param aDescription    群组描述
 @param aInvitees       默认群组成员（usernames，不需包括创建者自己）
 @param aWelcomeMessage 群组欢迎语
 @param aStyleSetting   群组属性配置
 @param pError          建组的错误。成功为nil
 @return 创建好的群组
 @discussion
 创建群组成功 判断条件：*pError == nil && returnGroup != nil
 */
- (EMGroup *)createGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupOptions *)styleSetting
                              error:(EMError **)pError;

/*!
 @method
 @brief  创建群组（异步方法）。函数执行完, 回调[group:didCreateWithError:]会被触发
 @param subject        群组名称
 @param description    群组描述
 @param invitees       默认群组成员（usernames）
 @param welcomeMessage 群组欢迎语
 @param styleSetting   群组属性配置
 */
- (void)asyncCreateGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupOptions *)styleSetting;

/*!
 @method
 @brief 创建群组（异步方法）。函数执行完, 会调用参数completion
 @param subject        群组名称
 @param description    群组描述
 @param invitees       默认群组成员（usernames）
 @param welcomeMessage 群组欢迎语
 @param styleSetting   群组属性配置
 @param completion     创建完成后的回调
 @param aQueue         回调block时的线程
 @discussion
 创建群组成功 判断条件：completion中，error == nil && group != nil
 */
- (void)asyncCreateGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupOptions *)styleSetting
                         completion:(void (^)(EMGroup *group,
                                              EMError *error))completion
                            onQueue:(dispatch_queue_t)aQueue;


/**
 @brief  获取与我相关的群组列表（自己创建的，加入的）(同步方法)
 @param pError 获取错误信息
 @return 群组列表
 @discussion
 获取列表成功 判断条件：*pError == nil && returnArray != nil
 */
- (NSArray *)fetchMyGroupsListWithError:(EMError **)pError;

/*!
 @method
 @brief      获取与我相关的群组列表（自己创建的，加入的）(异步方法)
 @discussion
 执行后, 回调[didUpdateGroupList:error]会被触发
 */
- (void)asyncFetchMyGroupsList;

/*!
 @method
 @brief 获取与我相关的群组列表（自己创建的，加入的）(异步方法)
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
 获取列表成功 判断条件：completion中，error == nil && groups != nil
 */
- (void)asyncFetchMyGroupsListWithCompletion:(void (^)(NSArray *groups,
                                                       EMError *error))completion
                                     onQueue:(dispatch_queue_t)aQueue;


/*!
 @method
 @brief 获取指定范围内的公开群
 @param cursor   获取公开群的cursor，首次调用传空即可
 @param pageSize 期望结果的数量, 如果 < 0 则一次返回所有结果
 @param pError   出错信息
 @return         获取的公开群结果
 @discussion
 这是一个阻塞方法，用户应当在一个独立线程中执行此方法，用户可以连续调用此方法以获得所有的公开群
 */
- (EMCursorResult *)fetchPublicGroupsFromServerWithCursor:(NSString *)cursor
                                                 pageSize:(NSInteger)pageSize
                                                 andError:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取指定范围的公开群
 @param cursor      获取公开群的cursor，首次调用传空即可
 @param pageSize    期望结果的数量, 如果 < 0 则一次返回所有结果
 @param completion  完成回调，回调会在主线程调用
 */
- (void)asyncFetchPublicGroupsFromServerWithCursor:(NSString *)cursor
                                          pageSize:(NSInteger)pageSize
                                     andCompletion:(void (^)(EMCursorResult *result, EMError *error))completion;

#pragma mark - leave group

/*!
 @method
 @brief 退出群组
 @param groupId  群组ID
 @param pError   错误信息
 @result 退出的群组对象, 失败返回nil
 */
- (EMGroup *)leaveGroup:(NSString *)groupId
                  error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 退出群组
 @param groupId  群组ID
 @discussion
 函数执行完, 回调group:didLeave:error:会被触发
 */
- (void)asyncLeaveGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 退出群组
 @param groupId  群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncLeaveGroup:(NSString *)groupId
             completion:(void (^)(EMGroup *group,
                                  EMGroupLeaveReason reason,
                                  EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue;

#pragma mark - destroy group

/*!
 @method
 @brief 同步方法， 解散群组，需要owner权限
 @param groupId  群组ID
 @param pError   错误信息
 @result 退出的群组对象, 失败返回nil
 */
- (EMGroup *)destroyGroup:(NSString *)groupId
                    error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 解散群组，需要owner权限
 @param groupId  群组ID
 @discussion
 函数执行完, 回调group:didLeave:error:会被触发
 */
- (void)asyncDestroyGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 解散群组，需要owner权限
 @param groupId  群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncDestroyGroup:(NSString *)groupId
               completion:(void (^)(EMGroup *group,
                                    EMGroupLeaveReason reason,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue;

#pragma mark - add occupants

/*!
 @method
 @brief 邀请用户加入群组
 @param occupants      被邀请的用户名列表
 @param groupId        群组ID
 @param welcomeMessage 欢迎信息
 @param pError         错误信息
 @result 返回群组对象, 失败返回空
 */
- (EMGroup *)addOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage
                    error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 邀请用户加入群组
 @param occupants      被邀请的用户名列表
 @param groupId        群组ID
 @param welcomeMessage 欢迎信息
 @discussion
 函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncAddOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage;

/*!
 @method
 @brief 异步方法, 邀请用户加入群组
 @param occupants      被邀请的用户名列表
 @param groupId        群组ID
 @param welcomeMessage 欢迎信息
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 */
- (void)asyncAddOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage
               completion:(void (^)(NSArray *occupants,
                                    EMGroup *group,
                                    NSString *welcomeMessage,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue;

#pragma mark - remove occupants

/*!
 @method
 @brief 将某些人请出群组
 @param occupants 要请出群组的人的用户名列表
 @param groupId   群组ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
 此操作需要admin/owner权限
 */
- (EMGroup *)removeOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId
                       error:(EMError *__autoreleasing *)pError;

/*!
 @method
 @brief 异步方法, 将某些人请出群组
 @param occupants 要请出群组的人的用户名列表
 @param groupId   群组ID
 @discussion
 此操作需要admin/owner权限.
 函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncRemoveOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 将某些人请出群组
 @param occupants  要请出群组的人的用户名列表
 @param groupId    群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
 此操作需要admin/owner权限
 */
- (void)asyncRemoveOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId
                  completion:(void (^)(EMGroup *group,
                                       EMError *error))completion
                     onQueue:(dispatch_queue_t)aQueue;

#pragma mark - block occupants

/*!
 @method
 @brief 将某些人加入群组黑名单
 @param occupants 要加入黑名单的用户名列表
 @param groupId   群组ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
 此操作需要admin/owner权限, 被加入黑名单的人, 不会再被允许进入群组
 */
- (EMGroup *)blockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId
                      error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 将某些人加入群组黑名单
 @param occupants 要加入黑名单的用户名列表
 @param groupId   群组ID
 @discussion
 此操作需要admin/owner权限, 被加入黑名单的人, 不会再被允许进入群组
 函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncBlockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 将某些人加入群组黑名单
 @param occupants   要加入黑名单的用户名列表
 @param groupId     群组ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
 此操作需要admin/owner权限, 被加入黑名单的人, 不会再被允许进入群组
 */
- (void)asyncBlockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId
                 completion:(void (^)(EMGroup *group,
                                      EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue;

#pragma mark - unblock occupants

/*!
 @method
 @brief 将某些人从群组黑名单中解除
 @param occupants 要从黑名单中移除的用户名列表
 @param groupId   群组ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
 此操作需要admin/owner权限, 从黑名单中移除后, 可以再次进入群组
 */
- (EMGroup *)unblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId
                        error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 将某些人从群组黑名单中解除
 @param occupants 要从黑名单中移除的用户名列表
 @param groupId   群组ID
 @discussion
 此操作需要admin/owner权限, 从黑名单中移除后, 可以再次进入群组
 函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncUnblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 将某些人从群组黑名单中解除
 @param occupants   要从黑名单中移除的用户名列表
 @param groupId     群组ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
 此操作需要admin/owner权限, 从黑名单中移除后, 可以再次进入群组
 */
- (void)asyncUnblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId
                   completion:(void (^)(EMGroup *group,
                                        EMError *error))completion
                      onQueue:(dispatch_queue_t)aQueue;

#pragma mark - change group subject

/*!
 @method
 @brief 更改群组主题
 @param subject  主题
 @param groupId  群组ID
 @param pError   错误信息
 @result 返回群组对象
 @discussion
 此操作需要admin/owner权限
 */
- (EMGroup *)changeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId
                          error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 更改群组主题
 @param subject  主题
 @param groupId  群组ID
 @discussion
 此操作需要admin/owner权限
 函数执行完, groupDidUpdateInfo:error:回调会被触发
 */
- (void)asyncChangeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 更改群组主题
 @param subject    主题
 @param groupId    群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
 此操作需要admin/owner权限
 */
- (void)asyncChangeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId
                     completion:(void (^)(EMGroup *group,
                                          EMError *error))completion
                        onQueue:(dispatch_queue_t)aQueue;

#pragma mark - change group description

/*!
 @method
 @brief 更改群组说明信息
 @param newDescription 说明信息
 @param groupId        群组ID
 @param pError         错误信息
 @result 返回群组对象
 @discussion
 此操作需要admin/owner权限
 */
- (EMGroup *)changeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId
                         error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 更改群组说明信息
 @param newDescription 说明信息
 @param groupId        群组ID
 @discussion
 此操作需要admin/owner权限.
 函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncChangeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 更改群组说明信息
 @param newDescription 说明信息
 @param groupId        群组ID
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 @discussion
 此操作需要admin/owner权限
 */
- (void)asyncChangeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId
                    completion:(void (^)(EMGroup *group,
                                         EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue;

#pragma mark - accept join group apply

/*!
 @method
 @brief 同意加入群组的申请
 @param groupId   所申请的群组ID
 @param groupname 申请的群组名称
 @param username  申请人的用户名
 @param pError    错误信息
 */
- (void)acceptApplyJoinGroup:(NSString *)groupId
                   groupname:(NSString *)groupname
                   applicant:(NSString *)username
                       error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 同意加入群组的申请
 @param groupId   所申请的群组ID
 @param groupname 申请的群组名称
 @param username  申请人的用户名
 @discussion
 函数执行后, didAcceptApplyJoinGroup:username:error:回调会被触发
 */
- (void)asyncAcceptApplyJoinGroup:(NSString *)groupId
                        groupname:(NSString *)groupname
                        applicant:(NSString *)username;

/*!
 @method
 @brief 异步方法, 同意加入群组的申请
 @param groupId    所申请的群组ID
 @param groupname  申请的群组名称
 @param username   申请人的用户名
 @param completion 消息完成后的回调
 @param aQueue     回调执行时的线程
 */
- (void)asyncAcceptApplyJoinGroup:(NSString *)groupId
                        groupname:(NSString *)groupname
                        applicant:(NSString *)username
                       completion:(void (^)(EMError *error))completion
                          onQueue:(dispatch_queue_t)aQueue;

#pragma mark - reject join group apply

/*!
 @method
 @brief 拒绝一个加入群组的申请
 @param groupId  被拒绝的群组ID
 @param username 被拒绝的人
 @param reason   拒绝理由
 */
- (void)rejectApplyJoinGroup:(NSString *)groupId
                   groupname:(NSString *)groupname
                 toApplicant:(NSString *)username
                      reason:(NSString *)reason;

#pragma mark - fetch group info

/*!
 @method
 @brief 获取群组详细信息（id，密码，主题，描述，实际总人数，在线人数，成员列表，属性）
 @param groupId 群组ID
 @param pError  错误信息
 @result 所获取的群组对象
 */
- (EMGroup *)fetchGroupInfo:(NSString *)groupId
                      error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取群组详细信息（id，密码，主题，描述，实际总人数，在线人数，成员列表，属性）
 @param groupId 群组ID
 @discussion
 执行后, 回调didFetchGroupInfo:error会被触发
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 获取群组详细信息（id，密码，主题，描述，实际总人数，在线人数，成员列表，属性）
 @param groupId    群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId
                 completion:(void (^)(EMGroup *group,
                                      EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue;

/*!
 @method
 @brief 同步方法, 获取群组成员列表
 @param groupId    群组ID
 @param pError     错误信息
 @return  群组的成员列表（包含创建者）
 */
- (NSArray *)fetchOccupantList:(NSString *)groupId error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取群组成员列表
 @param groupId    群组ID
 @discussion
 执行完成后，回调[didFetchGroupOccupantsList:error:]
 */
- (void)asyncFetchOccupantList:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 获取群组成员列表
 @param groupId    群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncFetchOccupantList:(NSString *)groupId
                    completion:(void (^)(NSArray *occupantsList,EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue;

/*!
 @method
 @brief 同步方法, 获取群组信息
 @param groupId             群组ID
 @param includesOccupantList 是否获取成员列表
 @param pError              错误信息
 @return 群组
 */
- (EMGroup *)fetchGroupInfo:(NSString *)groupId
       includesOccupantList:(BOOL)includesOccupantList
                      error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取群组成员列表
 @param groupId             群组ID
 @param includesOccupantList 是否获取成员列表
 @discussion
 执行完成后，回调[didFetchGroupInfo:error:]
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId
       includesOccupantList:(BOOL)includesOccupantList;

/*!
 @method
 @brief 异步方法, 获取群组成员列表
 @param groupId             群组ID
 @param includesOccupantList 是否获取成员列表
 @param completion          消息完成后的回调
 @param aQueue              回调block时的线程
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId
       includesOccupantList:(BOOL)includesOccupantList
                 completion:(void (^)(EMGroup *group,EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue;

#pragma mark - fetch group bans
/*!
 @method
 @brief 同步方法, 获取群组黑名单列表
 @param groupId  群组ID
 @return         群组黑名单列表
 @discussion
 需要owner权限
 */
- (NSArray *)fetchGroupBansList:(NSString *)groupId error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取群组黑名单列表
 @param groupId  群组ID
 @discussion
 需要owner权限
 执行完成后，回调[didFetchGroupBans:list:error:]
 */
- (void)asyncFetchGroupBansList:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 获取群组黑名单列表
 @param groupId             群组ID
 @param completion          消息完成后的回调
 @param aQueue              回调block时的线程
 @discussion
 需要owner权限
 */
- (void)asyncFetchGroupBansList:(NSString *)groupId
                     completion:(void (^)(NSArray *groupBans,EMError *error))completion
                        onQueue:(dispatch_queue_t)aQueue;

#pragma mark - join public group

/*!
 @method
 @brief 加入一个公开群组
 @param groupId 公开群组的ID
 @param pError  错误信息
 @result 所加入的公开群组
 @discussion
 成功标志：*pError == nil;
 */
- (EMGroup *)joinPublicGroup:(NSString *)groupId error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 加入一个公开群组
 @param groupId 公开群组的ID
 @discussion
 执行后, 回调didJoinPublicGroup:error:会被触发
 成功标志：error == nil;
 */
- (void)asyncJoinPublicGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 加入一个公开群组
 @param groupId    公开群组的ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
 成功标志：error == nil;
 */
- (void)asyncJoinPublicGroup:(NSString *)groupId
                  completion:(void (^)(EMGroup *group,
                                       EMError *error))completion
                     onQueue:(dispatch_queue_t)aQueue;

#pragma mark - Apply to join public group, Founded in 2.0.3 version

/*!
 @method
 @brief 同步方法, 申请加入一个需授权的公开群组
 @param groupId             公开群组的ID
 @param groupName           请求加入的群组名称
 @param message             请求加入的信息
 @param pError              错误信息
 @result 所加入的公开群组
 */
- (EMGroup *)applyJoinPublicGroup:(NSString *)groupId
                    withGroupname:(NSString *)groupName
                          message:(NSString *)message
                            error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 申请加入一个需授权的公开群组
 @param groupId             公开群组的ID
 @param groupName           请求加入的群组名称
 @param message             请求加入的信息
 @discussion
 执行后, 回调didApplyJoinPublicGroup:error:会被触发
 */
- (void)asyncApplyJoinPublicGroup:(NSString *)groupId
                    withGroupname:(NSString *)groupName
                          message:(NSString *)message;

/*!
 @method
 @brief 异步方法, 申请加入一个需授权的公开群组
 @param groupId             公开群组的ID
 @param groupName           请求加入的群组名称
 @param message             请求加入的信息
 @param completion          消息完成后的回调
 @param aQueue              回调block时的线程
 */
- (void)asyncApplyJoinPublicGroup:(NSString *)groupId
                    withGroupname:(NSString *)groupName
                          message:(NSString *)message
                       completion:(void (^)(EMGroup *group,
                                            EMError *error))completion
                          onQueue:(dispatch_queue_t)aQueue;

/*!
 @method
 @brief  根据groupId搜索公开群(同步方法)
 @param groupId  群组id(完整id)
 @param pError   搜索失败的错误
 @return 搜索到的群组
 @discussion
 搜索群组成功 判断条件：*pError == nil && returnGroup != nil
 */
- (EMGroup *)searchPublicGroupWithGroupId:(NSString *)groupId
                                    error:(EMError **)pError;

/*!
 @method
 @brief  根据groupId搜索公开群(异步方法)
 @param groupId    公开群组的ID(完整id)
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
 搜索群组成功 判断条件：completion中，error == nil && group != nil
 */
- (void)asyncSearchPublicGroupWithGroupId:(NSString *)groupId
                               completion:(void (^)(EMGroup *group,
                                                    EMError *error))completion
                                  onQueue:(dispatch_queue_t)aQueue;

#pragma mark - block group

/*!
 @method
 @brief 屏蔽群消息，服务器不发送消息(不能屏蔽自己创建的群，EMErrorInvalidUsername)
 @param groupId   要屏蔽的群ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
 被屏蔽的群，服务器不再发消息
 */
- (EMGroup *)blockGroup:(NSString *)groupId
                  error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 屏蔽群消息，服务器不发送消息(不能屏蔽自己创建的群，EMErrorInvalidUsername)
 @param groupId     要取消屏蔽的群ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
 被屏蔽的群，服务器不再发消息
 */
- (void)asyncBlockGroup:(NSString *)groupId
             completion:(void (^)(EMGroup *group,
                                  EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue;

/*!
 @method
 @brief 取消屏蔽群消息(不能操作自己创建的群，EMErrorInvalidUsername)
 @param groupId   要取消屏蔽的群ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
 */
- (EMGroup *)unblockGroup:(NSString *)groupId
                    error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 取消屏蔽群消息(不能操作自己创建的群，EMErrorInvalidUsername)
 @param groupId     要取消屏蔽的群ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
 */
- (void)asyncUnblockGroup:(NSString *)groupId
               completion:(void (^)(EMGroup *group,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue;
////////////////////////////////////////////////////////////////////////////////////////////////
//deprecated -----
- (NSArray *)fetchAllPublicGroupsWithError:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");
- (void)asyncFetchAllPublicGroups EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");
- (void)asyncFetchAllPublicGroupsWithCompletion:(void (^)(NSArray *groups,
                                                          EMError *error))completion
                                        onQueue:(dispatch_queue_t)aQueue EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");
@end
