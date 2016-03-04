//
//  IChatManagerLoginDelegate.h
//  SDKChange
//
//  Created by 杜洁鹏 on 3/5/16.
//  Copyright © 2016 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IChatManagerLoginDelegate <NSObject>

@optional

- (void)didLoginWithInfo:(NSDictionary *)loginInfo
                   error:(EMError *)error;


- (void)didRegisterNewAccount:(NSString *)username
                     password:(NSString *)password
                        error:(EMError *)error;

- (void)didLogoffWithError:(EMError *)error;
@end
