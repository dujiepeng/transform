//
//  EChatManager+PushNotification.m
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManager+PushNotification.h"

@implementation EChatManager (PushNotification)
@dynamic pushNotificationOptions;
@dynamic ignoredGroupIds;


#pragma mark - getter/setter

- (EMPushOptions *)pushNotificationOptions
{
    return [EMClient sharedClient].pushOptions;
}

- (NSArray *)ignoredGroupIds
{
    return [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];
}


#pragma mark - push notification apis

- (EMPushOptions *)updatePushOptions:(EMPushOptions *)options
                               error:(EMError **)pError{

    EMError *error = [[EMClient sharedClient] updatePushOptionsToServer];
    if (pError) {
        *pError = error;
    }
    
    return [EMClient sharedClient].pushOptions;
}

- (void)asyncUpdatePushOptions:(EMPushOptions *)options{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMPushOptions *newOption = [weakSelf updatePushOptions:options error:&error];
        [_delegates didUpdatePushOptions:newOption
                                   error:error];
    });
}

- (void)asyncUpdatePushOptions:(EMPushOptions *)options
                    completion:(void (^)(EMPushOptions *options, EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMPushOptions *newOption = [weakSelf updatePushOptions:options error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(newOption, error);
            });
        }
    });
}

#pragma mark - ignore group push notification

- (NSArray *)ignoreGroupPushNotification:(NSString *)groupId
                                  ignore:(BOOL)ignore
                                   error:(EMError **)pError{
    EMError *error = [[EMClient sharedClient].groupManager ignoreGroupPush:groupId ignore:ignore];
    if (pError) {
        *pError = error;
    }
    
    return [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];
}

- (void)asyncIgnoreGroupPushNotification:(NSString *)groupId
                                isIgnore:(BOOL)isIgnore{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSArray *ret = nil;
        EMError *error = nil;
        ret = [weakSelf ignoreGroupPushNotification:groupId
                                             ignore:isIgnore
                                              error:&error];
        [_delegates didIgnoreGroupPushNotification:ret
                                             error:error];
    });
}

- (void)asyncIgnoreGroupPushNotification:(NSString *)groupId
                                isIgnore:(BOOL)isIgnore
                              completion:(void (^)(NSArray *ignoreGroupsList,
                                                   EMError *error))aCompletion
                                 onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSArray *ret = nil;
        EMError *error = nil;
        ret = [weakSelf ignoreGroupPushNotification:groupId
                                             ignore:isIgnore
                                              error:&error];
        dispatch_queue_t queue = aQueue;
        if (!queue) {
            queue = dispatch_get_main_queue();
        }
        dispatch_async(queue, ^(){
            aCompletion(ret, error);
        });
    });
}

@end
