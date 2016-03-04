//
//  EaseMob.h
//  ChatDemo-UI2.0
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSDK.h"
#import "IChatManager.h"
#import "EaseMobDefine.h"

@interface EaseMob : NSObject
@property (nonatomic, readonly, strong) id<IChatManager> chatManager;
+ (instancetype)sharedInstance;

- (EMError *)registerSDKWithAppKey:(NSString *)anAppKey
                      apnsCertName:(NSString *)anAPNSCertName
                       otherConfig:(NSDictionary *)anOtherConfig;

@end
