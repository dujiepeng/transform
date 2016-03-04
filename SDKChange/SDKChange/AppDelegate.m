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
    // Override point for customization after application launch.
    EMOptions *option = [EMOptions optionsWithAppkey:@"easemob-demo#chatdemoui"];
//    option.enableConsoleLog = YES;
    [[EMClient sharedClient] initializeSDKWithOptions:option];
    [[EMClient sharedClient] loginWithUsername:@"6001" password:@"111111"];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
    
    return YES;
}

-(void)didUpdateGroupList:(NSArray *)groupList error:(EMError *)error{
    
}


@end
