//
//  EChatManager+Conversation.m
//  SDKChange
//
//  Created by WYZ on 16/3/5.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import "EChatManager+Conversation.h"

@implementation EChatManager (Conversation)

- (NSArray *)conversations
{
    return [[EMClient sharedClient].chatManager getAllConversations];
}

#pragma mark - database

//获取某个用户的会话
- (EMConversation *)conversationForChatter:(NSString *)chatter
                          conversationType:(EMConversationType)type
{
    if (!chatter) {
        return nil;
    }
    return [[EMClient sharedClient].chatManager getConversation:chatter type:type createIfNotExist:YES];;
}

//从数据库获取当前登录用户的会话列表,执行后会更新内存中的会话列表
- (NSArray *)loadAllConversationsFromDatabase
{
    NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    [_delegates didUpdateConversationList:conversations];
    return conversations;
}



#pragma mark - save

//保存单个会话对象到数据库
- (BOOL)importConversationToDB:(EMConversation *)conversation
{
    if (conversation) {
        return NO;
    }
    return [[EMClient sharedClient].chatManager importConversations:@[conversation]];
}

//保存多个个会话对象到数据库
- (BOOL)importConversationsToDB:(NSArray<EMConversation *> *)conversations
{
    if (conversations || conversations.count == 0) {
        return NO;
    }
    return [[EMClient sharedClient].chatManager importConversations:conversations];
}

#pragma mark - remove

//删除某个会话对象
- (BOOL)removeConversationByChatter:(NSString *)conversationId
                     deleteMessages:(BOOL)aDeleteMessages
{
    if (!conversationId) {
        return NO;
    }
    return [[EMClient sharedClient].chatManager deleteConversation:conversationId
                                                    deleteMessages:aDeleteMessages];
}

//删除某几个会话对象
- (BOOL)removeConversationsByChatters:(NSArray<EMConversation *> *)conversations
                       deleteMessages:(BOOL)aDeleteMessages
{
    if (conversations || conversations.count == 0) {
        return NO;
    }
    return [[EMClient sharedClient].chatManager deleteConversations:conversations
                                                     deleteMessages:aDeleteMessages];
}

#pragma mark - message counter

//从数据库获取所有未读消息数量
- (NSUInteger)loadTotalUnreadMessagesCountFromDatabase
{
    NSArray *conversayions = [self loadAllConversationsFromDatabase];
    __block NSUInteger unreadCount = 0;
    if (!conversayions || conversayions.count == 0) {
        return unreadCount;
    }
    [conversayions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[EMConversation class]])
        {
            EMConversation *conversation = (EMConversation *)obj;
            unreadCount += conversation.unreadMessagesCount;
        }
    }];
    return unreadCount;
}

//获取单个会话对象的未读消息数量
- (NSUInteger)unreadMessagesCountForConversation:(NSString *)conversationId
                                conversationType:(EMConversationType)conversationType;
{
    if (!conversationId) {
        return 0;
    }
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:conversationId type:conversationType createIfNotExist:YES];
    return conversation.unreadMessagesCount;
}

#pragma mark - save message

//保存聊天消息到D
- (BOOL)insertMessageToDB:(EMMessage *)message
{
    if (!message) {
        return NO;
    }
    return [[EMClient sharedClient].chatManager importMessages:@[message]];
}

//保存一组聊天消息
- (BOOL)insertMessagesToDB:(NSArray<EMMessage *> *)messages
{
    if (messages || messages.count == 0) {
        return NO;
    }
    return [[EMClient sharedClient].chatManager importMessages:messages];
}

@end
