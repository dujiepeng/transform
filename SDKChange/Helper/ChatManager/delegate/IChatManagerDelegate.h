//
//  IChatManagerDelegate.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMSDK.h"
#import "IChatManagerGroupDelegate.h"
#import "IChatManagerLoginDelegate.h"
#import "IChatManagerChatDelegate.h"
@protocol IChatManagerDelegate
<
    IChatManagerChatDelegate,
    EMChatroomManagerDelegate,
    EMContactManagerDelegate,

    IChatManagerGroupDelegate,
    IChatManagerLoginDelegate
>

@end
