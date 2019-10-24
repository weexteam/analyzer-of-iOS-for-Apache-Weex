//
//  WeexAnalyzer.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>
#import <WeexAnalyzer/WXAMenuItem.h>
#import <WeexAnalyzer/WXAMenuProtocol.h>
#import <WeexAnalyzer/WXALogModel.h>
#import <WeexAnalyzer/WXALogProtocol.h>
#import <WeexAnalyzer/WXALogMenuItem.h>
#import <WeexAnalyzer/WXALogFilterModel.h>
#import <WeexAnalyzer/WXABaseViewController.h>
#import <WeexAnalyzer/WXABaseTableViewController.h>
#import <WeexAnalyzer/WXAPageTabbar.h>

@interface WeexAnalyzer : NSObject

+ (void)enableDebugMode;
+ (void)disableDebugMode;

+ (void)bindWXInstance:(WXSDKInstance *)wxInstance;
+ (void)unbindWXInstance;

+ (void)addMenuItem:(WXAMenuItem *)item;

@end
