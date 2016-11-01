//
//  WXAUtility.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/20.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WXSDKInstance.h>

// 屏幕宽度T
#define WXA_SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
// 屏幕高度
#define WXA_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

void WXASwapInstanceMethods(Class cls, SEL original, SEL replacement);

@interface WXAUtility : NSObject

+ (WXSDKInstance *)findCurrentWeexInstance;

@end
