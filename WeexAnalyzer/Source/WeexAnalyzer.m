//
//  WeexAnalyzer.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WeexAnalyzer.h"
#import "WXAMenuView.h"
#import <WeexSDK/WXSDKManager.h>
#import "WXAUtility.h"
#import "WeexAnalyzerDefine.h"
#import "WXAWXExternalLogger.h"
#import "WXALogMenuItem.h"
#import "WXAPerformanceMenuItem.h"
#import "WXAStorageMenuItem.h"

static NSString *const WXAShowDevMenuNotification = @"WXAShowDevMenuNotification";

@implementation UIWindow (WeexMonitorClient)

- (void)WXA_motionEnded:(__unused UIEventSubtype)motion withEvent:(UIEvent *)event
{
#ifdef WXADevMode
    if (event.subtype == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WXAShowDevMenuNotification object:nil];
    }
#endif
}

@end

@interface WeexAnalyzer ()

@property (nonatomic, strong) NSArray<WXAMenuItem *> *items;
@property (nonatomic, strong) WXSDKInstance *wxInstance;

@end

@implementation WeexAnalyzer

+ (instancetype)sharedInstance {
    static WeexAnalyzer *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[WeexAnalyzer alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
#ifdef WXADevMode
        _items = [NSArray array];
        
        WXALogMenuItem *wxLogItem = [[WXALogMenuItem alloc] initWithTitle:@"JS日志" logger:[WXAWXExternalLogger new]];
        WXAPerformanceMenuItem *perfItem = [WXAPerformanceMenuItem new];
        WXAStorageMenuItem *storageItem = [WXAStorageMenuItem new];
        
        _items = @[wxLogItem, perfItem, storageItem];
        
        WXASwapInstanceMethods([UIWindow class], @selector(motionEnded:withEvent:), @selector(WXA_motionEnded:withEvent:));
        [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(shakeAction:)
                                                     name:WXAShowDevMenuNotification
                                                   object:nil];
#endif
    }
    return self;
}

#pragma mark - public method
+ (void)enableDebugMode {
#ifdef WXADevMode
    [WeexAnalyzer sharedInstance];
#endif
}

+ (void)disableDebugMode {
#ifdef WXADevMode
    [[WeexAnalyzer sharedInstance] free];
#endif
}

+ (void)bindWXInstance:(WXSDKInstance *)wxInstance {
#ifdef WXADevMode
    [WeexAnalyzer sharedInstance].wxInstance = wxInstance;
#endif
}

+ (void)unbindWXInstance:(WXSDKInstance *)wxInstance {
#ifdef WXADevMode
    [WeexAnalyzer sharedInstance].wxInstance = nil;
#endif
}

+ (void)addMenuItem:(WXAMenuItem *)item {
#ifdef WXADevMode
    [[WeexAnalyzer sharedInstance] addItem:item];
#endif
}

#pragma mark - actions
- (void)shakeAction:(id)sender {
#ifdef WXADevMode
    [self show];
#endif
}

- (void)show {
#ifdef WXADevMode
    WXAMenuView *menu = [[WXAMenuView alloc] initWithItems:_items];
    [menu showMenu];
#endif
}

- (void)addItem:(WXAMenuItem *)item {
#ifdef WXADevMode
    NSMutableArray *array = [_items mutableCopy];
    [array addObject:item];
    _items = [array copy];
    
    item.wxInstance = self.wxInstance;
#endif
}

- (void)free {
#ifdef WXADevMode
    _items = nil;
    _wxInstance = nil;
#endif
}

#pragma mark - Setters
- (void)setWxInstance:(WXSDKInstance *)wxInstance {
#ifdef WXADevMode
    _wxInstance = wxInstance;
    
    for (WXAMenuItem *item in self.items) {
        item.wxInstance = wxInstance;
    }
#endif
}

@end
