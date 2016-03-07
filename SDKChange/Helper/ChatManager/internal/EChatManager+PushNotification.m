//
//  EChatManager+PushNotification.m
//  SDKChange
//
//  Created by WYZ on 16/3/6.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import "EChatManager+PushNotification.h"

@implementation EChatManager (PushNotification)

#pragma mark - push notification properties
- (EMPushOptions *)pushNotificationOptions
{
    return [EMClient sharedClient].pushOptions;
}

- (NSArray *)ignoredGroupIds
{
    return [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];
}

/*!
 @method
 @brief 更新消息推送相关属性配置（同步方法）
 @param options    属性
 @param pError     更新错误信息
 @result    最新的属性配置
 */
- (EMPushOptions *)updatePushOptions:(EMPushOptions *)options
                               error:(EMError **)pError
{
    EMPushOptions *_options = [[EMClient sharedClient] pushOptions];
    _options.displayStyle = options.displayStyle;
    _options.nickname = options.nickname;
    _options.noDisturbStatus = options.noDisturbStatus;
    _options.noDisturbingStartH = options.noDisturbingStartH;
    _options.noDisturbingEndH = options.noDisturbingEndH;
    EMError *error = nil;
    error = [[EMClient sharedClient] updatePushOptionsToServer];
    if (pError) {
        *pError = error;
    }
    if (error) {
        return nil;
    }
    return _options;
}

/*!
 @method
 @brief 更新消息推送相关属性配置（异步方法）
 @param options    属性
 @discussion
 方法执行完之后，调用[didUpdatePushOptions:error:];
 */
- (void)asyncUpdatePushOptions:(EMPushOptions *)options
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMPushOptions *_options = [weakSelf updatePushOptions:options
                                                        error:&error];
        [_delegates didUpdatePushOptions:_options error:error];
    });
}

/*!
 @method
 @brief 更新消息推送相关属性配置(异步方法)
 @param options    属性
 @param completion 回调
 @param aQueue     回调时的线程
 @result
 */
- (void)asyncUpdatePushOptions:(EMPushOptions *)options
                    completion:(void (^)(EMPushOptions *options, EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMPushOptions *_options = [weakSelf updatePushOptions:options
                                                        error:&error];
        
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(_options, error);
            });
        }
    });
}


#pragma mark - ignore group push notification

// 屏蔽/接收群的推送消息
- (NSArray *)ignoreGroupPushNotification:(NSString *)groupId
                                  ignore:(BOOL)ignore
                                   error:(EMError **)pError
{
    EMError *error = [[EMClient sharedClient].groupManager ignoreGroupPush:groupId ignore:ignore];
    if (pError) {
        *pError = error;
    }
    if (error) {
        return nil;
    }
    return [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];
}

/*!
 @method
 @brief 屏蔽接收群的推送消息, 异步方法
 @param groupId    需要屏蔽/取消屏蔽 推送消息的群ID
 @param isIgnore   屏蔽/取消屏蔽
 @discussion
 全局的屏蔽推送消息属性优先于此设置;
 方法执行完之后，调用[didIgnoreGroupPushNotification:error:].
 */
- (void)asyncIgnoreGroupPushNotification:(NSString *)groupId
                                isIgnore:(BOOL)isIgnore
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *ignoredGroupIds = [weakSelf ignoreGroupPushNotification:groupId
                                                                  ignore:isIgnore
                                                                   error:&error];
        [_delegates didIgnoreGroupPushNotification:ignoredGroupIds error:error];
    });
}

/*!
 @method
 @brief 屏蔽接收群的推送消息, 异步方法
 @param groupId    需要屏蔽/取消屏蔽 推送消息的群ID
 @param isIgnore   屏蔽/取消屏蔽
 @param completion 回调
 @param aQueue     回调时的线程
 @discussion
 全局的屏蔽推送消息属性优先于此设置;
 */
- (void)asyncIgnoreGroupPushNotification:(NSString *)groupId
                                isIgnore:(BOOL)isIgnore
                              completion:(void (^)(NSArray *ignoreGroupsList,
                                                   EMError *error))completion
                                 onQueue:(dispatch_queue_t)aQueue
{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSArray *ignoredGroupIds = [weakSelf ignoreGroupPushNotification:groupId
                                                                  ignore:isIgnore
                                                                   error:&error];
        
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(ignoredGroupIds, error);
            });
        }
    });
}

@end
