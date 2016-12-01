//
//  WXAPerformanceManager.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/29.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAPerformanceManager.h"
#import "WXAPerformanceView.h"
#import "WXAPerformanceModel.h"
#import "WXAPerformanceHelper.h"
#import <objc/message.h>

@interface WXAPerformanceManager ()

@property (nonatomic, strong) WXAPerformanceView *container;

@end

@implementation WXAPerformanceManager

#pragma mark - public methods
- (void)show {
    [self refreshData];
    [self.container show];
}

- (void)hide {
    [self.container hide];
}

- (void)free {
    
}

#pragma mark - private methods
- (void)refreshData {
    NSArray *basicData = [self getBasicData];
    NSArray *performanceData = [self getPerformanceData];
    NSArray *globalData = [self getGlobalPerformanceData];
    
    self.container.data = @[basicData, performanceData, globalData];
}

- (NSArray *)getBasicData {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[self modelForTitle:@"Weex SDK Version" value:WX_SDK_VERSION category:WXAPerformanceCategoryBasic]];
    [array addObject:[self modelForTitle:@"JS Framework Version" value:[WXAppConfiguration JSFrameworkVersion] category:WXAPerformanceCategoryBasic]];
    
    if (self.wxInstance) {
        [array addObject:[self modelForTitle:@"Page Name" value:self.wxInstance.pageName category:WXAPerformanceCategoryBasic]];
        [array addObject:[self modelForTitle:@"Template Url" value:self.wxInstance.scriptURL.absoluteString category:WXAPerformanceCategoryBasic]];
    }
    
    /*[array addObject:[self modelForTitle:@"Total Components"
                                   value:[NSString stringWithFormat:@"%ld",self.wxInstance.numberOfComponents]
                                category:WXAPerformanceCategoryBasic]];*/
    
    if (self.wxInstance.userInfo[@"weex_bundlejs_connectionType"]) {
        [array addObject:[self modelForTitle:@"weex_bundlejs_connectionType"
                                       value:self.wxInstance.userInfo[@"weex_bundlejs_connectionType"]
                                    category:WXAPerformanceCategoryBasic]];
    }
    
    if (self.wxInstance.userInfo[@"weex_bundlejs_requestType"]) {
        [array addObject:[self modelForTitle:@"weex_bundlejs_requestType"
                                       value:self.wxInstance.userInfo[@"weex_bundlejs_requestType"]
                                    category:WXAPerformanceCategoryBasic]];
    }
    
    return [array copy];
}

- (NSArray *)getPerformanceData {
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *perfDict = self.wxInstance.performanceDict;
    
    for (id key in perfDict) {
        NSDictionary *tagDict = perfDict[key];
        if (tagDict && tagDict.count == 2 && tagDict[@"start"] && tagDict[@"end"]) {
            NSString *tagKey = [WXAPerformanceHelper performanceStrForTag:key];
            double start = [tagDict[@"start"] doubleValue];
            double end = [tagDict[@"end"] doubleValue];
            NSString *diffStr = [NSString stringWithFormat:@"%.2f",end - start];
            
            [array addObject:[self modelForTitle:tagKey value:diffStr category:WXAPerformanceCategoryPerformance]];
        }
    }
    
    return [array copy];
}

- (NSArray *)getGlobalPerformanceData {
    // get performanceDictForInstance method
    SEL globalDictSel = NSSelectorFromString(@"performanceDictForInstance:");
    if (![WXMonitor instanceMethodForSelector:globalDictSel]) {
        return [NSArray array];
    }
    
    // storageQueue
    Class wxMonitorClass = [WXMonitor class];
    Method method = class_getClassMethod(wxMonitorClass, globalDictSel);
    if (!method) {
        return [NSArray array];
    }
    
    NSDictionary *perfDict = [((NSMutableDictionary* (*)(id, SEL, WXSDKInstance *instance))objc_msgSend)(wxMonitorClass, method_getName(method), nil) copy];
    NSMutableArray *array = [NSMutableArray array];

    for (id key in perfDict) {
        NSDictionary *tagDict = perfDict[key];
        if (tagDict && tagDict.count == 2 && tagDict[@"start"] && tagDict[@"end"]) {
            NSString *tagKey = [WXAPerformanceHelper performanceStrForTag:key];
            double start = [tagDict[@"start"] doubleValue];
            double end = [tagDict[@"end"] doubleValue];
            NSString *diffStr = [NSString stringWithFormat:@"%.2f",end - start];
            
            [array addObject:[self modelForTitle:tagKey value:diffStr category:WXAPerformanceCategoryGlobal]];
        }
    }
    return array;
}

- (WXAPerformanceModel *)modelForTitle:(NSString *)title
                                 value:(NSString *)value
                              category:(WXAPerformanceCategory)category {
    return [[WXAPerformanceModel alloc] initWithTitle:title value:value category:category];
}

#pragma mark - Getters
- (WXAPerformanceView *)container {
    if (!_container) {
        _container = [[WXAPerformanceView alloc] init];
    }
    return _container;
}

@end
