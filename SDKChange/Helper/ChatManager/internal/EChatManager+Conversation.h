//
//  EChatManager+Conversation.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManagerBase.h"
#import "IChatManagerConversation.h"

@interface EChatManager (Conversation) <IChatManagerConversation>
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
 @brief 获取当前登录用户的会话列表
 @param append2Chat  是否加到内存中。
 YES为加到内存中。加到内存中之后, 会有相应的回调被触发从而更新UI;
 NO为不加到内存中。如果不加到内存中, 则只会直接添加进DB, 不会有SDK的回调函数被触发从而去更新UI。
 @result 会话对象列表
 */
- (NSArray *)loadAllConversationsFromDatabaseWithAppend2Chat:(BOOL)append2Chat;

#pragma mark - save

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
                   append2Chat:(BOOL)append2Chat;

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
- (NSUInteger)insertConversationsToDB:(NSArray *)conversations
                          append2Chat:(BOOL)append2Chat;

#pragma mark - remove

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
 */- (BOOL)removeConversationByChatter:(NSString *)chatter
                     deleteMessages:(BOOL)aDeleteMessages
                        append2Chat:(BOOL)append2Chat;

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
                                append2Chat:(BOOL)append2Chat;

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
                                     append2Chat:(BOOL)append2Chat;

@end
