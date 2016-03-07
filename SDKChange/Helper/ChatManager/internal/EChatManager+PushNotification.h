//
//  EChatManager+PushNotification.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManagerBase.h"
#import "IChatManagerPushNotification.h"

@class EMPushOptions;
@interface EChatManager (PushNotification)<IChatManagerPushNotification>
#pragma mark - push notification properties
@property (nonatomic, strong, readonly) EMPushOptions *pushNotificationOptions;
@property (nonatomic, strong, readonly) NSArray *ignoredGroupIds;

#pragma mark - push notification apis

- (EMPushOptions *)updatePushOptions:(EMPushOptions *)options
                               error:(EMError **)pError;

- (void)asyncUpdatePushOptions:(EMPushOptions *)options;

- (void)asyncUpdatePushOptions:(EMPushOptions *)options
                    completion:(void (^)(EMPushOptions *options, EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue;

#pragma mark - ignore group push notification

- (NSArray *)ignoreGroupPushNotification:(NSString *)groupId
                                  ignore:(BOOL)ignore
                                   error:(EMError **)pError;

- (void)asyncIgnoreGroupPushNotification:(NSString *)groupId
                                isIgnore:(BOOL)isIgnore;

- (void)asyncIgnoreGroupPushNotification:(NSString *)groupId
                                isIgnore:(BOOL)isIgnore
                              completion:(void (^)(NSArray *ignoreGroupsList,
                                                   EMError *error))aCompletion
                                 onQueue:(dispatch_queue_t)aQueue;
@end
