//
//  EChatManager+Chatroom.m
//  SDKChange
//
//  Created by 杜洁鹏 on 3/7/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import "EChatManager+Chatroom.h"

@implementation EChatManager (Chatroom)

#pragma mark - join/leave chatroom

- (EMChatroom *)joinChatroom:(NSString *)chatroomId
                       error:(EMError **)pError{
    EMError *error = nil;
    EMChatroom *ret = [[EMClient sharedClient].roomManager joinChatroom:chatroomId
                                                                  error:&error];
    if (pError) {
        *pError = error;
    }
    
    return ret;
}

- (void)asyncJoinChatroom:(NSString *)chatroomId
               completion:(void (^)(EMChatroom *chatroom,
                                    EMError *error))completion{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMChatroom *ret = [weakSelf joinChatroom:chatroomId
                                           error:&error];
        if (completion)
        {
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^(){
                completion(ret, error);
            });
        }
    });
}

- (EMChatroom *)leaveChatroom:(NSString *)chatroomId
                        error:(EMError **)pError{
    EMError *error = nil;
    EMChatroom *ret = [[EMClient sharedClient].roomManager leaveChatroom:chatroomId
                                                                   error:&error];
    if (pError) {
        *pError = error;
    }
    
    return ret;
}

- (void)asyncLeaveChatroom:(NSString *)chatroomId
                completion:(void (^)(EMChatroom *chatroom, EMError *error))completion{
    __weak EChatManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMChatroom *ret = [weakSelf leaveChatroom:chatroomId
                                            error:&error];
        if (completion)
        {
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^(){
                completion(ret, error);
            });
        }
    });
}

@end
