//
//  EMChatManager+Group.m
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManager+Group.h"
#import "EMSDK.h"


@implementation EChatManager (Group)

-(NSArray *)groupList{
    return [[EMClient sharedClient].groupManager getAllGroups];
}

- (NSArray *)loadAllMyGroupsFromDatabaseWithAppend2Chat:(BOOL)append2Chat{
    return [[EMClient sharedClient].groupManager loadAllMyGroupsFromDB];
}

- (EMGroup *)createGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupOptions *)styleSetting
                              error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:subject
                                                                      description:description
                                                                         invitees:invitees
                                                                          message:welcomeMessage
                                                                          setting:styleSetting
                                                                            error:&error];
    if(pError){
        *pError = error;
    }
    

    
    return group;
}

- (void)asyncCreateGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupOptions *)styleSetting{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *createGroup = [weakSelf createGroupWithSubject:subject
                                                    description:description
                                                       invitees:invitees
                                          initialWelcomeMessage:welcomeMessage
                                                   styleSetting:styleSetting
                                                          error:&error];
        [_delegates group:createGroup didCreateWithError:error];
    });
}

- (void)asyncCreateGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupOptions *)styleSetting
                         completion:(void (^)(EMGroup *group,
                                              EMError *error))completion
                            onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *createGroup = [weakSelf createGroupWithSubject:subject
                                                    description:description
                                                       invitees:invitees
                                          initialWelcomeMessage:welcomeMessage
                                                   styleSetting:styleSetting
                                                          error:&error];
        
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            
            dispatch_async(queue, ^(){
                completion(createGroup, error);
            });
        }
    });
}



// fetch group list
- (NSArray *)fetchMyGroupsListWithError:(EMError **)pError{
    EMError *error = nil;
    NSArray *ret = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
    if (pError) {
        *pError = error;
    }
    

    
    return ret;
}

- (void)asyncFetchMyGroupsList{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *myGroups = [weakSelf fetchMyGroupsListWithError:&error];
        [_delegates didUpdateGroupList:myGroups error:error];
    });
}

- (void)asyncFetchMyGroupsListWithCompletion:(void (^)(NSArray *groups,
                                                       EMError *error))completion
                                     onQueue:(dispatch_queue_t)aQueue
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *myGroups = [weakSelf fetchMyGroupsListWithError:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(myGroups, error);
            });
        }
    });
}

- (EMCursorResult *)fetchPublicGroupsFromServerWithCursor:(NSString *)cursor
                                                 pageSize:(NSInteger)pageSize
                                                 andError:(EMError **)pError{
    EMError *error = nil;
    EMCursorResult *result = [[EMClient sharedClient].groupManager getPublicGroupsFromServerWithCursor:cursor
                                                                                              pageSize:pageSize
                                                                                                 error:&error];
    if (pError) {
        *pError = error;
    }
    

    
    return result;
}


- (void)asyncFetchPublicGroupsFromServerWithCursor:(NSString *)cursor
                                          pageSize:(NSInteger)pageSize
                                     andCompletion:(void (^)(EMCursorResult *result, EMError *error))completion{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMCursorResult *result = [weakSelf fetchPublicGroupsFromServerWithCursor:cursor
                                                                        pageSize:pageSize
                                                                        andError:&error];
        if (completion) {
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^(){
                completion(result, error);
            });
        }
    });
}

// leave group
- (EMGroup *)leaveGroup:(NSString *)groupId
                  error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager leaveGroup:groupId error:&error];
    if (pError) {
        *pError = error;
    }
    

    
    return group;
}

- (void)asyncLeaveGroup:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf leaveGroup:groupId error:&error];
        [_delegates group:group didLeave:EMGroupLeaveReasonUserLeave error:error];
    });
}

- (void)asyncLeaveGroup:(NSString *)groupId
             completion:(void (^)(EMGroup *group,
                                  EMGroupLeaveReason reason,
                                  EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf leaveGroup:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(group, EMGroupLeaveReasonUserLeave, error);
            });
        }
    });
}

//destroy group
- (EMGroup *)destroyGroup:(NSString *)groupId
                    error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager destroyGroup:groupId error:&error];
    if (pError) {
        *pError = error;
    }
    

    
    return group;
}

- (void)asyncDestroyGroup:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf destroyGroup:groupId error:&error];
        [_delegates group:group didLeave:EMGroupLeaveReasonDestroyed error:error];
    });
}

- (void)asyncDestroyGroup:(NSString *)groupId
               completion:(void (^)(EMGroup *group,
                                    EMGroupLeaveReason reason,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf destroyGroup:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(group, EMGroupLeaveReasonDestroyed, error);
            });
        }
    });
}

- (EMGroup *)addOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage
                    error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager addOccupants:occupants
                                                                toGroup:groupId
                                                         welcomeMessage:welcomeMessage
                                                                  error:&error];
    
    if (pError) {
        *pError = error;
    }
    

    
    return group;
}

- (void)asyncAddOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf addOccupants:occupants
                                        toGroup:groupId
                                 welcomeMessage:welcomeMessage
                                          error:&error];
        [_delegates groupDidUpdateInfo:group error:error];
    });
}

- (void)asyncAddOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage
               completion:(void (^)(NSArray *occupants,
                                    EMGroup *group,
                                    NSString *welcomeMessage,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue{
    
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf addOccupants:occupants
                                        toGroup:groupId
                                 welcomeMessage:welcomeMessage
                                          error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(occupants, group, welcomeMessage, error);
            });
        }
    });
}

//remove occupants
- (EMGroup *)removeOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId
                       error:(EMError *__autoreleasing *)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager removeOccupants:occupants
                                                                 fromGroup:groupId
                                                                     error:&error];
    if (pError) {
        *pError = error;
    }
    

    
    return group;
}

- (void)asyncRemoveOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf removeOccupants:occupants
                                         fromGroup:groupId
                                             error:&error];
        [_delegates groupDidUpdateInfo:group error:error];
    });
}

- (void)asyncRemoveOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId
                  completion:(void (^)(EMGroup *group,
                                       EMError *error))completion
                     onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf removeOccupants:occupants
                                         fromGroup:groupId
                                             error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(group, error);
            });
        }
    });
}

//block occupants
- (EMGroup *)blockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId
                      error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager blockOccupants:occupants
                                                                fromGroup:groupId
                                                                    error:&error];
    if (pError) {
        *pError = error;
    }
    

    
    return group;
}

- (void)asyncBlockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf blockOccupants:occupants
                                        fromGroup:groupId
                                            error:&error];
        
        [_delegates groupDidUpdateInfo:group error:error];
    });
}

- (void)asyncBlockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId
                 completion:(void (^)(EMGroup *group,
                                      EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf blockOccupants:occupants
                                        fromGroup:groupId
                                            error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(group, error);
            });
        }
    });
}

- (EMGroup *)unblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId
                        error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager unblockOccupants:occupants
                                                                   forGroup:groupId
                                                                      error:&error];
    if (pError) {
        *pError = error;
    }
    

    
    return group;
}

- (void)asyncUnblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf unblockOccupants:occupants
                                           forGroup:groupId
                                              error:&error];
        [_delegates groupDidUpdateInfo:group error:error];
    });
}

- (void)asyncUnblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId
                   completion:(void (^)(EMGroup *group,
                                        EMError *error))completion
                      onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf unblockOccupants:occupants
                                           forGroup:groupId
                                              error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(group, error);
            });
            
        }
    });
}

//change group subject
- (EMGroup *)changeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId
                          error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager changeGroupSubject:subject
                                                                     forGroup:groupId
                                                                        error:&error];
    
    if (pError) {
        *pError = error;
    }
    

    
    return group;
}

- (void)asyncChangeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf changeGroupSubject:subject forGroup:groupId error:&error];
        [_delegates groupDidUpdateInfo:group error:error];
    });
}

- (void)asyncChangeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId
                     completion:(void (^)(EMGroup *group,
                                          EMError *error))completion
                        onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf changeGroupSubject:subject forGroup:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(group, error);
            });
        };
    });
}

//change group description

- (EMGroup *)changeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId
                         error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager changeDescription:newDescription
                                                                    forGroup:groupId
                                                                       error:&error];
    if (pError) {
        *pError = error;
    }
    

    
    return group;
}

- (void)asyncChangeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf changeDescription:newDescription forGroup:groupId error:&error];
        [_delegates groupDidUpdateInfo:group error:error];
    });
}

- (void)asyncChangeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId
                    completion:(void (^)(EMGroup *group,
                                         EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf changeDescription:newDescription forGroup:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(group, error);
            });
        }
    });
}

//accept join group apply

- (void)acceptApplyJoinGroup:(NSString *)groupId
                   groupname:(NSString *)groupname
                   applicant:(NSString *)username
                       error:(EMError **)pError{
    EMError *error = [[EMClient sharedClient].groupManager acceptJoinApplication:groupId
                                                                       applicant:username];
    if (pError) {
        *pError = error;
    }
}

- (void)asyncAcceptApplyJoinGroup:(NSString *)groupId
                        groupname:(NSString *)groupname
                        applicant:(NSString *)username{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [weakSelf acceptApplyJoinGroup:groupId
                             groupname:groupname
                             applicant:username
                                 error:&error];
        [_delegates didAcceptApplyJoinGroup:groupId username:username error:error];
    });
}

- (void)asyncAcceptApplyJoinGroup:(NSString *)groupId
                        groupname:(NSString *)groupname
                        applicant:(NSString *)username
                       completion:(void (^)(EMError *error))completion
                          onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [weakSelf acceptApplyJoinGroup:groupId
                             groupname:groupname
                             applicant:username
                                 error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(error);
            });
        }
    });
}

//reject join group apply
- (void)rejectApplyJoinGroup:(NSString *)groupId
                   groupname:(NSString *)groupname
                 toApplicant:(NSString *)username
                      reason:(NSString *)reason{
    [[EMClient sharedClient].groupManager declineJoinApplication:groupId
                                                       applicant:username
                                                          reason:reason];
}

#pragma mark - fetch group info

/*!
 @method
 @brief 获取群组详细信息（id，密码，主题，描述，实际总人数，在线人数，成员列表，属性）
 @param groupId 群组ID
 @param pError  错误信息
 @result 所获取的群组对象
 */
- (EMGroup *)fetchGroupInfo:(NSString *)groupId
                      error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:groupId
                                                       includeMembersList:NO
                                                                    error:&error];
    
    if (pError) {
        *pError = error;
    }
    

    
    return group;
}

/*!
 @method
 @brief 异步方法, 获取群组详细信息（id，密码，主题，描述，实际总人数，在线人数，成员列表，属性）
 @param groupId 群组ID
 @discussion
 执行后, 回调didFetchGroupInfo:error会被触发
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf fetchGroupInfo:groupId error:&error];
        [_delegates didFetchGroupInfo:group error:error];
    });
}

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
                    onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf fetchGroupInfo:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(group, error);
            });
        }
    });
}


- (NSArray *)fetchOccupantList:(NSString *)groupId error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:groupId
                                                       includeMembersList:YES
                                                                    error:&error];
    if (pError) {
        *pError = error;
    }
    

    
    return group.occupants;
}


- (void)asyncFetchOccupantList:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *occupants = [weakSelf fetchOccupantList:groupId error:&error];
        [_delegates didFetchGroupOccupantsList:occupants error:error];
    });
}

- (void)asyncFetchOccupantList:(NSString *)groupId
                    completion:(void (^)(NSArray *occupantsList,EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *occupants = [weakSelf fetchOccupantList:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(occupants, error);
            });
        }
    });
}

- (EMGroup *)fetchGroupInfo:(NSString *)groupId
       includesOccupantList:(BOOL)includesOccupantList
                      error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:groupId
                                                       includeMembersList:includesOccupantList
                                                                    error:&error];
    if (pError) {
        *pError = error;
    }
    
    return group;
}

- (void)asyncFetchGroupInfo:(NSString *)groupId
       includesOccupantList:(BOOL)includesOccupantList{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf fetchGroupInfo:groupId includesOccupantList:includesOccupantList error:&error];
        [_delegates didFetchGroupInfo:group error:error];
    });
}

- (void)asyncFetchGroupInfo:(NSString *)groupId
       includesOccupantList:(BOOL)includesOccupantList
                 completion:(void (^)(EMGroup *group,EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [weakSelf fetchGroupInfo:groupId includesOccupantList:includesOccupantList error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(group, error);
            });
        }
    });
}

- (NSArray *)fetchGroupBansList:(NSString *)groupId error:(EMError **)pError{
    
    EMError *error = nil;
    NSArray *ret = [[EMClient sharedClient].groupManager fetchGroupBansList:groupId
                                                                      error:&error];
    if (pError) {
        *pError = error;
    }
    
    return ret;
}

- (void)asyncFetchGroupBansList:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *bans = [weakSelf fetchGroupBansList:groupId error:&error];
        [_delegates didFetchGroupBans:groupId list:bans error:error];
    });
}

- (void)asyncFetchGroupBansList:(NSString *)groupId
                     completion:(void (^)(NSArray *groupBans,EMError *error))completion
                        onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *bans = [weakSelf fetchGroupBansList:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(bans, error);
            });
        }
    });
}

#pragma mark - join public group

- (EMGroup *)joinPublicGroup:(NSString *)groupId error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager joinPublicGroup:groupId error:&error];
    if (pError) {
        *pError = error;
    }
    
    return group;
}

- (void)asyncJoinPublicGroup:(NSString *)groupId{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *ret = [weakSelf joinPublicGroup:groupId error:&error];
        [_delegates didJoinPublicGroup:ret error:error];
    });
}

- (void)asyncJoinPublicGroup:(NSString *)groupId
                  completion:(void (^)(EMGroup *group,
                                       EMError *error))completion
                     onQueue:(dispatch_queue_t)aQueue{
    
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *ret = [weakSelf joinPublicGroup:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(ret, error);
            });
        }
    });
}

#pragma mark - Apply to join public group, Founded in 2.0.3 version

- (EMGroup *)applyJoinPublicGroup:(NSString *)groupId
                    withGroupname:(NSString *)groupName
                          message:(NSString *)message
                            error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager applyJoinPublicGroup:groupId
                                                                        message:message
                                                                          error:&error];
    if (pError) {
        *pError = error;
    }
    
    return group;
}

- (void)asyncApplyJoinPublicGroup:(NSString *)groupId
                    withGroupname:(NSString *)groupName
                          message:(NSString *)message{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *ret = [weakSelf applyJoinPublicGroup:groupId
                                        withGroupname:groupName
                                              message:message
                                                error:&error];
        
        [_delegates didApplyJoinPublicGroup:ret error:error];
    });
}

- (void)asyncApplyJoinPublicGroup:(NSString *)groupId
                    withGroupname:(NSString *)groupName
                          message:(NSString *)message
                       completion:(void (^)(EMGroup *group,
                                            EMError *error))completion
                          onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *ret = [weakSelf applyJoinPublicGroup:groupId
                                        withGroupname:groupName
                                              message:message
                                                error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(ret, error);
            });
        }
    });
}

- (EMGroup *)searchPublicGroupWithGroupId:(NSString *)groupId
                                    error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager searchPublicGroupWithId:groupId error:&error];
    if (pError) {
        *pError = error;
    }
    
    return group;
}

- (void)asyncSearchPublicGroupWithGroupId:(NSString *)groupId
                               completion:(void (^)(EMGroup *group,
                                                    EMError *error))completion
                                  onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        
        EMError *error = nil;
        EMGroup *retGroup = [weakSelf searchPublicGroupWithGroupId:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(retGroup, error);
            });
        }
    });
}

#pragma mark - block group

- (EMGroup *)blockGroup:(NSString *)groupId
                  error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager blockGroup:groupId error:&error];
    if (pError) {
        *pError = error;
    }
    
    return group;
}

- (void)asyncBlockGroup:(NSString *)groupId
             completion:(void (^)(EMGroup *group,
                                  EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        
        EMError *error = nil;
        EMGroup *retGroup = [weakSelf blockGroup:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(retGroup, error);
            });
        }
    });
}

- (EMGroup *)unblockGroup:(NSString *)groupId
                    error:(EMError **)pError{
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager unblockGroup:groupId error:&error];
    if (pError) {
        *pError = error;
    }
    
    return group;
}

- (void)asyncUnblockGroup:(NSString *)groupId
               completion:(void (^)(EMGroup *group,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        
        EMError *error = nil;
        EMGroup *retGroup = [weakSelf unblockGroup:groupId error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(retGroup, error);
            });
        }
    });
}
// deprecated
- (NSArray *)fetchAllPublicGroupsWithError:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete"){
    return nil;
}
- (void)asyncFetchAllPublicGroups EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete"){
    
}
- (void)asyncFetchAllPublicGroupsWithCompletion:(void (^)(NSArray *groups,
                                                          EMError *error))completion
                                        onQueue:(dispatch_queue_t)aQueue EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete"){
    
}


@end
