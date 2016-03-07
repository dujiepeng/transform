//
//  IChatManagerConversationDelegate.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IChatManagerConversationDelegate <NSObject>
- (void)didUpdateConversationList:(NSArray *)conversationList;
@end
