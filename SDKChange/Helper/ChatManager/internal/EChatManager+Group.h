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

// create
- (EMGroup *)createGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupOptions *)styleSetting
                              error:(EMError **)pError;

- (void)asyncCreateGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupOptions *)styleSetting;

- (void)asyncCreateGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupOptions *)styleSetting
                         completion:(void (^)(EMGroup *group,
                                              EMError *error))completion
                            onQueue:(dispatch_queue_t)aQueue;


// fetch group list
- (NSArray *)fetchMyGroupsListWithError:(EMError **)pError;
- (void)asyncFetchMyGroupsList;
- (void)asyncFetchMyGroupsListWithCompletion:(void (^)(NSArray *groups,
                                                       EMError *error))completion
                                     onQueue:(dispatch_queue_t)aQueue;


- (EMCursorResult *)fetchPublicGroupsFromServerWithCursor:(NSString *)cursor
                                                 pageSize:(NSInteger)pageSize
                                                 andError:(EMError **)pError;


- (void)asyncFetchPublicGroupsFromServerWithCursor:(NSString *)cursor
                                          pageSize:(NSInteger)pageSize
                                     andCompletion:(void (^)(EMCursorResult *result, EMError *error))completion;


- (NSArray *)fetchAllPublicGroupsWithError:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");
- (void)asyncFetchAllPublicGroups EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");
- (void)asyncFetchAllPublicGroupsWithCompletion:(void (^)(NSArray *groups,
                                                          EMError *error))completion
                                        onQueue:(dispatch_queue_t)aQueue EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");
@end
