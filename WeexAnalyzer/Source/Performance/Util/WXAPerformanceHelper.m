//
//  WXAPerformanceHelper.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/29.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAPerformanceHelper.h"
#import <WeexSDK/WeexSDK.h>

@implementation WXAPerformanceHelper

+ (NSString *)performanceStrForTag:(id)tag {
    
    static NSDictionary *commitKeyDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commitKeyDict = @{
                          @(WXPTInitalize) : SDKINITTIME,
                          @(WXPTInitalizeSync) : SDKINITINVOKETIME,
                          @(WXPTFrameworkExecute) : JSLIBINITTIME,
                          @(WXPTJSDownload) : NETWORKTIME,
                          @(WXPTJSCreateInstance) : COMMUNICATETIME,
                          @(WXPTFirstScreenRender) : SCREENRENDERTIME,
                          @(WXPTAllRender) : TOTALTIME,
                          @(WXPTBundleSize) : JSTEMPLATESIZE
                          };
    });
    
    return commitKeyDict[tag];
}

@end
