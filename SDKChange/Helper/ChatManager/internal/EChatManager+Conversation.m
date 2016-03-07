//
//  EChatManager+Conversation.m
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManager+Conversation.h"

@implementation EChatManager (Conversation)
@dynamic conversations;
#pragma mark - properties

- (NSArray *)conversations
{
    return [[EMClient sharedClient].chatManager getAllConversations];
}
#pragma mark - database
- (EMConversation *)conversationForChatter:(NSString *)chatter
                          conversationType:(EMConversationType)type{
    return [[EMClient sharedClient].chatManager getConversation:chatter
                                                           type:type
                                               createIfNotExist:YES];
}

- (NSArray *)loadAllConversationsFromDatabaseWithAppend2Chat:(BOOL)append2Chat{
    NSArray *ret = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    if (append2Chat) {
        [_delegates didUpdateConversationList:self.conversations];
    }
    
    return ret;
}

#pragma mark - insert conversation

- (BOOL)insertConversationToDB:(EMConversation *)conversation
                   append2Chat:(BOOL)append2Chat{
    BOOL ret = [[EMClient sharedClient].chatManager importConversations:@[conversation]];
    if (append2Chat) {
        [_delegates didUpdateConversationList:self.conversations];
    }
    
    return ret;
}

- (NSUInteger)insertConversationsToDB:(NSArray *)conversations
                          append2Chat:(BOOL)append2Chat{
    NSUInteger count = 0;
    for (EMConversation *conversation in conversations) {
        if ([[EMClient sharedClient].chatManager importConversations:@[conversation]]) {
            count += 1;
        }
    }
    
    return count;
}

#pragma mark - remove conversation

- (BOOL)removeConversationByChatter:(NSString *)chatter
                     deleteMessages:(BOOL)aDeleteMessages
                        append2Chat:(BOOL)append2Chat{
    BOOL ret = [[EMClient sharedClient].chatManager deleteConversation:chatter deleteMessages:aDeleteMessages];
    if (append2Chat) {
        [_delegates didUpdateConversationList:self.conversations];
    }
    
    return ret;
}

- (NSUInteger)removeConversationsByChatters:(NSArray *)chatters
                             deleteMessages:(BOOL)aDeleteMessages
                                append2Chat:(BOOL)append2Chat{
    NSUInteger count = 0;
    for (NSString *chatter in chatters) {
        if ([[EMClient sharedClient].chatManager deleteConversation:chatter deleteMessages:aDeleteMessages]) {
            count += 1;
        }
    }
    
    return count;
}

- (BOOL)removeAllConversationsWithDeleteMessages:(BOOL)aDeleteMessages
                                     append2Chat:(BOOL)append2Chat{
    if (self.conversations.count > 0) {
        BOOL ret = [[EMClient sharedClient].chatManager deleteConversations:self.conversations
                                                             deleteMessages:aDeleteMessages];
        if (append2Chat) {
            [_delegates didUpdateConversationList:self.conversations];
        }
        return ret;
    }
    
    return NO;
}

#pragma mark - message counter


@end
