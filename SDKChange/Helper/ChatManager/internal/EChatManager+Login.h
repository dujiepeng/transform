//
//  EChatManager+Login.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManagerBase.h"
#import "IChatManagerLogin.h"
#import "EaseMobDefine.h"

@interface EChatManager (Login) <IChatManagerLogin>

@property (nonatomic, strong, readonly) NSDictionary *loginInfo;
//@property (nonatomic, readonly) BOOL isLoggedIn;
//@property (nonatomic, readonly) BOOL isConnected;

- (EMError *)loadDataFromDatabase;

- (BOOL)registerNewAccount:(NSString *)username
                  password:(NSString *)password
                     error:(EMError **)pError;

- (void)asyncRegisterNewAccount:(NSString *)username
                       password:(NSString *)password;

- (void)asyncRegisterNewAccount:(NSString *)username
                       password:(NSString *)password
                 withCompletion:(void (^)(NSString *username,
                                          NSString *password,
                                          EMError *error))completion
                        onQueue:(dispatch_queue_t)aQueue;

- (NSDictionary *)loginWithUsername:(NSString *)username
                           password:(NSString *)password
                              error:(EMError **)pError;

- (void)asyncLoginWithUsername:(NSString *)username
                      password:(NSString *)password;

- (void)asyncLoginWithUsername:(NSString *)username
                      password:(NSString *)password
                    completion:(void (^)(NSDictionary *loginInfo, EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue;

- (NSDictionary *)logoffWithUnbindDeviceToken:(BOOL)isUnbind
                                        error:(EMError **)pError;

- (void)asyncLogoffWithUnbindDeviceToken:(BOOL)isUnbind;

- (void)asyncLogoffWithUnbindDeviceToken:(BOOL)isUnbind
                              completion:(void (^)(NSDictionary *info, EMError *error))completion
                                 onQueue:(dispatch_queue_t)aQueue;

@end
