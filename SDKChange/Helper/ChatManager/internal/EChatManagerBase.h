//
//  EChatManagerBase.h
//  ChatDemo-UI2.0
//
//  Created by 杜洁鹏 on 3/4/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IChatManagerDelegate.h"
#import "IChatManagerBase.h"
#import "EMGCDMulticastDelegate.h"
@interface EChatManager : NSObject <IChatManagerBase>
{
    EMGCDMulticastDelegate<IChatManagerDelegate> *_delegates;// delegates
}
@property (strong, nonatomic) EMGCDMulticastDelegate<IChatManagerDelegate> *delegates;
+ (EChatManager *)sharedInstance;
#pragma mark - delegate
- (void)addDelegate:(id<IChatManagerDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;
- (void)removeDelegate:(id<IChatManagerDelegate>)delegate;
@end
