//
//  IChatManagerBase.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IChatManagerDelegate;
@protocol IChatManagerBase <NSObject>
@required
- (void)addDelegate:(id<IChatManagerDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;

- (void)removeDelegate:(id<IChatManagerDelegate>)delegate;

@end
