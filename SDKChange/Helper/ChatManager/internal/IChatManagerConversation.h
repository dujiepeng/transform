//
//  IChatManagerConversation.h
//  SDKChange
//
//  Created by WYZ on 16/3/5.
//  Copyright © 2016年 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IChatManagerBase.h"
#import "EaseMobDefine.h"

/*!
 @protocol
 @brief 本协议主要用于聊天数据库的操作, 包括获取会话对象、保存会话对象、删除会话对象、获取会话未读记录的条数等
 @discussion
 */
@protocol IChatManagerConversation <IChatManagerBase>


@optional

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

@optional
#pragma DEPRECATED_IOS

/*!
 @method
 @brief 获取当前登录用户的会话列表
 @param append2Chat  是否加到内存中。
 YES为加到内存中。加到内存中之后, 会有相应的回调被触发从而更新UI;
 NO为不加到内存中。如果不加到内存中, 则只会直接添加进DB, 不会有SDK的回调函数被触发从而去更新UI。
 @result 会话对象列表
 */
- (NSArray *)loadAllConversationsFromDatabaseWithAppend2Chat:(BOOL)append2Chat EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");

/*!
 @method
 @brief 保存单个会话对象到数据库
 @discussion 对数据库中取出的数据修改后, 需要调用该方法
 @param conversation 需要保存的会话对象
 @param append2Chat  是否加到内存中。
 YES为加到内存中。加到内存中之后, 会有相应的回调被触发从而更新UI;
 NO为不加到内存中。如果不加到内存中, 则只会直接添加进DB, 不会有SDK的回调函数被触发从而去更新UI。
 @result 保存成功或失败
 */
- (BOOL)insertConversationToDB:(EMConversation *)conversation
                   append2Chat:(BOOL)append2Chat EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete") ;

/*!
 @method
 @brief 保存多个会话对象到数据库
 @discussion
 @param conversations 需要保存的会话对象列表
 @param append2Chat   是否加到内存中。
 YES为加到内存中。加到内存中之后, 会有相应的回调被触发从而更新UI;
 NO为不加到内存中。如果不加到内存中, 则只会直接添加进DB, 不会有SDK的回调函数被触发从而去更新UI。
 @result 保存成功的会话对象个数
 */
- (NSInteger)insertConversationsToDB:(NSArray *)conversations
                         append2Chat:(BOOL)append2Chat EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");

/*!
 @method
 @brief 删除某个会话对象
 @discussion
 @param chatter 这个会话对象所对应的用户名
 @param aDeleteMessages 是否删除这个会话对象所关联的聊天记录
 @param append2Chat  是否加到内存中。
 YES为加到内存中。加到内存中之后, 会有相应的回调被触发从而更新UI;
 NO为不加到内存中。如果不加到内存中, 则只会直接添加进DB, 不会有SDK的回调函数被触发从而去更新UI。
 @result 删除成功或失败
 */
- (BOOL)removeConversationByChatter:(NSString *)chatter
                     deleteMessages:(BOOL)aDeleteMessages
                        append2Chat:(BOOL)append2Chat EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");

/*!
 @method
 @brief 删除某几个会话对象
 @discussion
 @param chatters 这几个要被删除的会话对象所对应的用户名列表
 @param aDeleteMessages 是否删除这个会话对象所关联的聊天记录
 @param append2Chat     是否加到内存中。
 YES为加到内存中。加到内存中之后, 会有相应的回调被触发从而更新UI;
 NO为不加到内存中。如果不加到内存中, 则只会直接添加进DB, 不会有SDK的回调函数被触发从而去更新UI。
 @result 成功删除的会话对象的个数
 */
- (NSUInteger)removeConversationsByChatters:(NSArray *)chatters
                             deleteMessages:(BOOL)aDeleteMessages
                                append2Chat:(BOOL)append2Chat EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");

/*!
 @method
 @brief 删除所有会话对象
 @discussion
 @param aDeleteMessages 是否删除这个会话对象所关联的聊天记录
 @param append2Chat     是否加到内存中。
 YES为加到内存中。加到内存中之后, 会有相应的回调被触发从而更新UI;
 NO为不加到内存中。如果不加到内存中, 则只会直接添加进DB, 不会有SDK的回调函数被触发从而去更新UI。
 @result 是否成功执行
 */
- (BOOL)removeAllConversationsWithDeleteMessages:(BOOL)aDeleteMessages
                                     append2Chat:(BOOL)append2Chat EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");

/*!
 @method
 @brief 获取单个会话对象的未读消息数量
 @discussion
 @param chatter 此会话对象所对应的会话id
 @result 此绘画对象的未读消息数量
 */
- (NSUInteger)unreadMessagesCountForConversation:(NSString *)chatter EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");

/*!
 @method
 @brief 导入聊天消息
 @param message 待导入的聊天消息
 @param append2Chat 是否加到内存中。
 YES为加到内存中。加到内存中之后, 会有相应的回调被触发从而更新UI;
 NO为不加到内存中。如果不加到内存中, 则只会直接添加进DB, 不会有SDK的回调函数被触发从而去更新UI。
 @return 是否成功导入聊天消息
 */
- (BOOL)insertMessageToDB:(EMMessage *)message
              append2Chat:(BOOL)append2Chat EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");

/*!
 @method
 @brief 保存一组聊天消息(推荐用法，速度有惊喜哦)
 @param messages 待保存的聊天消息列表
 @param chatter  必填选项，message的conversationChatter
 @param append2Chat 是否加到内存中。
 YES为加到内存中。加到内存中之后, 会有相应的回调被触发从而更新UI;
 NO为不加到内存中。如果不加到内存中, 则只会直接添加进DB, 不会有SDK的回调函数被触发从而去更新UI。
 @return 是否成功插入
 */
- (BOOL)insertMessagesToDB:(NSArray *)messages
                forChatter:(NSString *)chatter
               append2Chat:(BOOL)append2Chat EM_DEPRECATED_IOS(2_0_0, 2_2_2, "Delete");

@end
