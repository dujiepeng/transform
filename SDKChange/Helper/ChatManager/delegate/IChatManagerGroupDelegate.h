//
//  IChatManagerGroupDelegate.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMGroupManagerDelegate.h"

@protocol IChatManagerGroupDelegate <EMGroupManagerDelegate>
@optional
- (void)didUpdateGroupList:(NSArray *)groupList
                     error:(EMError *)error;
@end
