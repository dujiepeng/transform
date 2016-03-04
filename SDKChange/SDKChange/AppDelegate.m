//
//  AppDelegate.m
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "IChatManagerDelegate.h"
@interface AppDelegate ()<IChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[EaseMob sharedInstance] registerSDKWithAppKey:@"easemob-demo#chatdemoui"
                                       apnsCertName:nil
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:@NO}];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    

    EMError *error = nil;
    [[EaseMob sharedInstance].chatManager loginWithUsername:@"6001" password:@"111111" error:&error];
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
    
    return YES;
}


-(void)didRegisterNewAccount:(NSString *)username
                    password:(NSString *)password
                       error:(EMError *)error{

}

-(void)didLogoffWithError:(EMError *)error{

}

-(void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{

}

@end
