//
//  IChatManagerGroup.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IChatManagerBase.h"

@protocol IChatManagerGroup <IChatManagerBase>

@required
@property (nonatomic, strong, readonly) NSArray *groupList;

- (NSArray *)loadAllMyGroupsFromDatabaseWithAppend2Chat:(BOOL)append2Chat;

- (NSArray *)fetchMyGroupsListWithError:(EMError **)pError;
- (void)asyncFetchMyGroupsList;
- (void)asyncFetchMyGroupsListWithCompletion:(void (^)(NSArray *groups,
                                                       EMError *error))completion
                                     onQueue:(dispatch_queue_t)aQueue;
@end
