//
//  EaseMob.m
//  ChatDemo-UI2.0
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EaseMob.h"
#import "EChatManager.h"
#import "EChatManagerBase.h"

@interface EaseMob ()
{
    id<IChatManager> _chatManager;
}
@end

@implementation EaseMob
+ (instancetype)sharedInstance{
    static EaseMob *easemob = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        easemob = [[EaseMob alloc] init];
    });
    
    return easemob;
}


- (id<IChatManager>)chatManager
{
    if (!_chatManager) {
        _chatManager = (id<IChatManager>)[EChatManager sharedInstance];
    }
    
    return _chatManager;
}
@end
