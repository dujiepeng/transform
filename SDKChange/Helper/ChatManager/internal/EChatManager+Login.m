//
//  EChatManager+Login.m
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManager+Login.h"

@implementation EChatManager (Login)

- (EMError *)loadDataFromDatabase{
    return nil;
}

- (BOOL)registerNewAccount:(NSString *)username
                  password:(NSString *)password
                     error:(EMError **)pError{
    
    EMError *error = [[EMClient sharedClient] registerWithUsername:username
                                                          password:password];
    if (pError) {
        *pError = error;
    }
    
    if (error) {
        return NO;
    }
    
    return YES;
}

- (void)asyncRegisterNewAccount:(NSString *)username
                       password:(NSString *)password{
    
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [weakSelf registerNewAccount:username password:password error:&error];
        [_delegates didRegisterNewAccount:username password:password error:error];
    });
}

- (void)asyncRegisterNewAccount:(NSString *)username
                       password:(NSString *)password
                 withCompletion:(void (^)(NSString *username,
                                          NSString *password,
                                          EMError *error))completion
                        onQueue:(dispatch_queue_t)aQueue{
    
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [weakSelf registerNewAccount:username password:password error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(username, password, error);
            });
        }
    });
}

- (NSDictionary *)loginWithUsername:(NSString *)username
                           password:(NSString *)password
                              error:(EMError **)pError{
    EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
    if (pError) {
        *pError = error;
    }
    
    return self.loginInfo;
}

- (void)asyncLoginWithUsername:(NSString *)username
                      password:(NSString *)password{
    
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSDictionary *ret = [weakSelf loginWithUsername:username
                                               password:password
                                                  error:&error];
        [_delegates didLoginWithInfo:ret error:error];
    });
}

- (void)asyncLoginWithUsername:(NSString *)username
                      password:(NSString *)password
                    completion:(void (^)(NSDictionary *loginInfo, EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue{
    
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        NSDictionary *ret = [weakSelf loginWithUsername:username
                                               password:password
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

- (NSDictionary *)logoffWithUnbindDeviceToken:(BOOL)isUnbind
                                        error:(EMError **)pError{
    EMError *error = [[EMClient sharedClient] logout:isUnbind];
    if (pError) {
        *pError = error;
    }
    
    return nil;
}

- (void)asyncLogoffWithUnbindDeviceToken:(BOOL)isUnbind{
    
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [weakSelf logoffWithUnbindDeviceToken:isUnbind error:&error];
        [_delegates didLogoffWithError:error];
    });
    
}

- (void)asyncLogoffWithUnbindDeviceToken:(BOOL)isUnbind
                              completion:(void (^)(NSDictionary *info, EMError *error))completion
                                 onQueue:(dispatch_queue_t)aQueue{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [weakSelf logoffWithUnbindDeviceToken:isUnbind error:&error];
        if (completion) {
            dispatch_queue_t queue = aQueue;
            if (!queue) {
                queue = dispatch_get_main_queue();
            }
            dispatch_async(queue, ^(){
                completion(nil, error);
            });
        }
    });
}

- (NSDictionary *)loginInfo
{
    NSDictionary *ret = nil;
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username) {
        ret = @{kSDKUsername:username};
    }
    return ret;
}

@end
