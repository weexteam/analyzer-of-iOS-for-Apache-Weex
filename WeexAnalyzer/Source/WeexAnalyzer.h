//
//  WeexAnalyzer.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>
#import "WXAMenuItem.h"

@interface WeexAnalyzer : NSObject

+ (void)enableDebugMode;
+ (void)disableDebugMode;

+ (void)bindWXInstance:(WXSDKInstance *)wxInstance;
+ (void)unbindWXInstance:(WXSDKInstance *)wxInstance;

+ (void)addMenuItem:(WXAMenuItem *)item;

@end
