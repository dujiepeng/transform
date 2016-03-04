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

@interface EChatManager (Group) <IChatManagerGroup>

#pragma mark - delegate
@property (nonatomic, strong, readonly) NSArray *groupList;

- (NSArray *)loadAllMyGroupsFromDatabaseWithAppend2Chat:(BOOL)append2Chat;

- (NSArray *)fetchMyGroupsListWithError:(EMError **)pError;
- (void)asyncFetchMyGroupsList;
- (void)asyncFetchMyGroupsListWithCompletion:(void (^)(NSArray *groups,
                                                       EMError *error))completion
                                     onQueue:(dispatch_queue_t)aQueue;
@end
