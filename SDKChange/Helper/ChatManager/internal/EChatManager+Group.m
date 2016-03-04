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


- (NSArray *)fetchMyGroupsListWithError:(EMError **)pError{
    EMError *error = nil;
    NSArray *ret = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
    if (error) {
        *pError = error;
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

@end
