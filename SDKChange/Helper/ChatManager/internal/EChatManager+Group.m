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
    
    if (error) {
        return nil;
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



// fetch group from server
- (NSArray *)fetchMyGroupsListWithError:(EMError **)pError{
    EMError *error = nil;
    NSArray *ret = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
    if (pError) {
        *pError = error;
    }
    
    if (error) {
        return nil;
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
    
    if (error) {
        return nil;
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
