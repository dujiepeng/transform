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

- (void)asyncFetchMyGroupsList{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *myGroups = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
        [_delegates didUpdateGroupList:myGroups error:error];
    });
}

@end
