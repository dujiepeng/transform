//
//  EChatManager+Conversation.h
//  SDKChange
//
//  Created by WYZ on 16/3/5.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import "EChatManagerBase.h"
#import "IChatManagerConversation.h"

@interface EChatManager (Conversation)<IChatManagerConversation>

#pragma mark - properties

/*!
 @property
 @brief 当前登陆用户的会话对象列表
 */
@property (nonatomic, readonly) NSArray *conversations;

#pragma mark - database

/*!
 @method
 @brief 获取某个用户的会话
 @discussion
 此方法获取会话的顺序如下:
 1. 查找内存会话列表中的会话;
 2. 如果没找到, 试图从数据库中查找此条会话;
 3. 如果仍没找到, 创建一个新的会话, 加到会话列表中, 并触发didUpdateConversationList:回调
 @param chatter 需要获取会话对象的用户名, 对于群组是群组ID，聊天室则是聊天室ID
 @result 会话对象
 */
- (EMConversation *)conversationForChatter:(NSString *)chatter
                          conversationType:(EMConversationType)type;

/*!
 @method
 @brief 从数据库获取当前登录用户的会话列表,执行后会更新内存中的会话列表
 @discussion
 这是一个阻塞方法，用户应当在一个独立线程中执行此方法
 @result 会话对象列表
 */
- (NSArray *)loadAllConversationsFromDatabase;

#pragma mark - save

/*!
 @method
 @brief 保存单个会话对象到数据库
 @discussion 对数据库中取出的数据修改后, 需要调用该方法
 @param conversation 需要保存的会话对象
 @result 保存成功或失败
 */
- (BOOL)importConversationToDB:(EMConversation *)conversation;

/*!
 @method
 @brief 保存多个个会话对象到数据库
 @discussion 对数据库中取出的数据修改后, 需要调用该方法
 @param conversations 需要保存的会话对象数组
 @result 保存成功或失败
 */
- (BOOL)importConversationsToDB:(NSArray<EMConversation *> *)conversations;

#pragma mark - remove

/*!
 @method
 @brief 删除某个会话对象
 @discussion
 @param conversationId 这个会话对象对应的会话id
 @param aDeleteMessages 是否删除这个会话对象所关联的聊天记录
 @result 删除成功或失败
 */
- (BOOL)removeConversationByChatter:(NSString *)conversationId
                     deleteMessages:(BOOL)aDeleteMessages;

/*!
 @method
 @brief 删除某几个会话对象
 @discussion
 @param conversations 这几个要被删除的会话对象列表
 @param aDeleteMessages 是否删除这个会话对象所关联的聊天记录
 @result 成功删除的会话对象的个数
 */
- (BOOL)removeConversationsByChatters:(NSArray<EMConversation *> *)conversations
                       deleteMessages:(BOOL)aDeleteMessages;

#pragma mark - message counter

/*!
 @method
 @brief 从数据库获取所有未读消息数量
 @discussion
 @result 未读消息数量
 */
- (NSUInteger)loadTotalUnreadMessagesCountFromDatabase;

/*!
 @method
 @brief 获取单个会话对象的未读消息数量
 @discussion
 @param conversationId 此会话对象所对应的会话id
 @param conversationType 此会话类型
 @result 此绘画对象的未读消息数量
 */
- (NSUInteger)unreadMessagesCountForConversation:(NSString *)conversationId
                                conversationType:(EMConversationType)conversationType;

#pragma mark - save message

/*!
 @method
 @brief 保存聊天消息到DB
 @param message 待保存的聊天消息
 @return 是否成功保存聊天消息
 @discussion
 消息会直接保存到数据库中,并不会调用相关回调方法,请自行调用[loadAllConversationsFromDatabase]更新会话列表
 */
- (BOOL)insertMessageToDB:(EMMessage *)message;


/*!
 @method
 @brief  保存一组聊天消息
 @param  messages 待保存的聊天消息列表
 @return 是否成功保存聊天消息
 @discussion
 消息会直接保存到数据库中,并不会调用相关回调方法,请自行调用[loadAllConversationsFromDatabase]更新会话列表
 */
- (BOOL)insertMessagesToDB:(NSArray<EMMessage *> *)messages;

@end
