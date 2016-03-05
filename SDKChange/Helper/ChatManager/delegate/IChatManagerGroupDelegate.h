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
- (void)group:(EMGroup *)group didCreateWithError:(EMError *)error;

- (void)didUpdateGroupList:(NSArray *)groupList
                     error:(EMError *)error;

- (void)group:(EMGroup *)group
     didLeave:(EMGroupLeaveReason)reason
        error:(EMError *)error;

- (void)groupDidUpdateInfo:(EMGroup *)group
                     error:(EMError *)error;
@end
