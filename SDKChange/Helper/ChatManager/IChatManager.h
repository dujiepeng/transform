//
//  IChatManager.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IChatManagerGroup.h"
#import "IChatManagerLogin.h"

@protocol IChatManager
<
    IChatManagerGroup,
    IChatManagerLogin
>

@end
