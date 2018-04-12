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
#import "WXAMenuProtocol.h"
#import "WXALogModel.h"
#import "WXALogProtocol.h"
#import "WXALogMenuItem.h"
#import "WXALogFilterModel.h"
#import "WXABaseViewController.h"
#import "WXABaseTableViewController.h"

@interface WeexAnalyzer : NSObject

+ (void)enableDebugMode;
+ (void)disableDebugMode;

+ (void)bindWXInstance:(WXSDKInstance *)wxInstance;
+ (void)unbindWXInstance;

+ (void)addMenuItem:(WXAMenuItem *)item;

@end
