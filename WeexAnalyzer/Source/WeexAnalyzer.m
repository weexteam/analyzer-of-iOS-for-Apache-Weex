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
#import <WeexSDK/WXHandlerFactory.h>
#import "WXAUtility.h"
#import "WeexAnalyzerDefine.h"
#import "WXAWXExternalLogger.h"
#import "WXALogMenuItem.h"
#import "WXAPerformanceMenuItem.h"
#import "WXAStorageMenuItem.h"
#import "WXAMenuDefaultImpl.h"
#import "WXAMonitorHandler.h"
#import "WXAApiTracingViewController.h"
#import "WXARenderTracingViewController.h"

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
        
        WXALogMenuItem *wxLogItem = [[WXALogMenuItem alloc] initWithTitle:@"JS日志"
                                                            iconImageName:@"wxt_icon_log"
                                                                   logger:[WXAWXExternalLogger new]];
        WXAPerformanceMenuItem *perfItem = [WXAPerformanceMenuItem new];
        WXAStorageMenuItem *storageItem = [WXAStorageMenuItem new];
        
        WXAMenuItem *apiItem = [WXAMenuItem new];
        WXAMenuItem * __weak _apiItem = apiItem;
        apiItem.title = @"api";
        apiItem.iconImage = [UIImage imageNamed:@"wxt_icon_log"];
        apiItem.handler = ^(BOOL selected) {
           WXABaseViewController *controller = [WXAApiTracingViewController new];
            [_apiItem show:controller];
        };
        
        WXAMenuItem *renderItem = [WXAMenuItem new];
        WXAMenuItem * __weak _renderItem = renderItem;
        renderItem.title = @"render";
        renderItem.iconImage = [UIImage imageNamed:@"wxt_icon_log"];
        renderItem.handler = ^(BOOL selected) {
            WXARenderTracingViewController *controller = [WXARenderTracingViewController new];
            [_renderItem show:controller];
        };
        
        _items = @[wxLogItem, perfItem, storageItem, apiItem, renderItem];
        
        WXASwapInstanceMethods([UIWindow class], @selector(motionEnded:withEvent:), @selector(WXA_motionEnded:withEvent:));
        WXPerformBlockOnMainThread(^{
            [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
        });
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(shakeAction:)
                                                     name:WXAShowDevMenuNotification
                                                   object:nil];
        
        [WXSDKEngine registerHandler:[WXAMenuDefaultImpl new] withProtocol:@protocol(WXAMenuProtocol)];
#endif
    }
    return self;
}

#pragma mark - public method
+ (void)enableDebugMode {
#ifdef WXADevMode
    [WeexAnalyzer sharedInstance];
    [WXAnalyzerCenter addWxAnalyzer:[WXAMonitorHandler sharedInstance]];
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

+ (void)unbindWXInstance {
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
    id<WXAMenuProtocol> menu = [WXSDKEngine handlerForProtocol:@protocol(WXAMenuProtocol)];
    if ([menu respondsToSelector:@selector(setWxInstance:)]) {
        [menu setWxInstance:wxInstance];
    }
#endif
}

@end
