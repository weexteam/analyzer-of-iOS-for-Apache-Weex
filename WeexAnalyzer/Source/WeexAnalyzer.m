//
//  WeexAnalyzer.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WeexAnalyzer.h"
#import "WXAMenuView.h"
#import <WeexSDK/WeexSDK.h>
#import "WXAUtility.h"
#import "WXAWXExternalLogger.h"
#import "WXALogMenuItem.h"
#import "WXAStorageMenuItem.h"
#import "WXAMenuDefaultImpl.h"
#import "WXAMonitorHandler.h"
#import "WXAApiTracingViewController.h"
#import "WXARenderTracingViewController.h"
#import "WXAPfmPageViewController.h"

static NSString *const WXAShowDevMenuNotification = @"WXAShowDevMenuNotification";

@implementation UIWindow (WeexMonitorClient)

- (void)WXA_motionEnded:(__unused UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WXAShowDevMenuNotification object:nil];
    }
}

@end

@interface WeexAnalyzer ()

@property (nonatomic, strong) NSArray<WXAMenuItem *> *items;
@property (nonatomic, weak) WXSDKInstance *wxInstance;
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
        
        [WXAnalyzerCenter addWxAnalyzer:[WXAMonitorHandler new]];
        [WXAnalyzerCenter setOpen:YES];
        
        WXALogMenuItem *wxLogItem = [[WXALogMenuItem alloc] initWithTitle:@"JS日志"
                                                            iconImageName:@"wxt_icon_log"
                                                                   logger:[WXAWXExternalLogger new]];
        WXAStorageMenuItem *storageItem = [WXAStorageMenuItem new];
        
        [WXTracingManager switchTracing:YES];
        
        WXAMenuItem *apiItem = [WXAMenuItem new];
        apiItem.title = @"api";
        apiItem.iconImage = [UIImage imageNamed:@"wxt_icon_log"];
        apiItem.controllerClass = WXAApiTracingViewController.self;
        
        WXAMenuItem *renderItem = [WXAMenuItem new];
        renderItem.title = @"render";
        renderItem.iconImage = [UIImage imageNamed:@"wxt_icon_multi_performance"];
        renderItem.controllerClass = WXARenderTracingViewController.self;
        
        WXAMenuItem *interactionItem = [WXAMenuItem new];
        interactionItem.title = @"可交互";
        interactionItem.iconImage = [UIImage imageNamed:@"wxt_icon_multi_performance"];
        interactionItem.controllerClass = WXAPfmPageViewController.self;
        
        _items = @[interactionItem, wxLogItem, storageItem, apiItem, renderItem];
        
        WXASwapInstanceMethods([UIWindow class], @selector(motionEnded:withEvent:), @selector(WXA_motionEnded:withEvent:));
        WXPerformBlockOnMainThread(^{
            [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
        });
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(shakeAction:)
                                                     name:WXAShowDevMenuNotification
                                                   object:nil];
        
        [WXSDKEngine registerHandler:[WXAMenuDefaultImpl new] withProtocol:@protocol(WXAMenuProtocol)];
    }
    return self;
}

#pragma mark - public method
+ (void)enableDebugMode {
    [WeexAnalyzer sharedInstance];
}

+ (void)disableDebugMode {
    [[WeexAnalyzer sharedInstance] free];
}

+ (void)bindWXInstance:(WXSDKInstance *)wxInstance {
    [WeexAnalyzer sharedInstance].wxInstance = wxInstance;
}

+ (void)unbindWXInstance {
    [WeexAnalyzer sharedInstance].wxInstance = nil;
}

+ (void)addMenuItem:(WXAMenuItem *)item {
    [[WeexAnalyzer sharedInstance] addItem:item];
}

#pragma mark - actions
- (void)shakeAction:(id)sender {
    [self show];
}

- (void)show {
    WXAMenuView *menu = [[WXAMenuView alloc] initWithItems:_items];
    [menu showMenu];
}

- (void)addItem:(WXAMenuItem *)item {
    NSMutableArray *array = [_items mutableCopy];
    [array addObject:item];
    _items = [array copy];
    
    item.wxInstance = self.wxInstance;
}

- (void)free {
    _items = nil;
    _wxInstance = nil;
}

#pragma mark - Setters
- (void)setWxInstance:(WXSDKInstance *)wxInstance {
    _wxInstance = wxInstance;
    
    for (WXAMenuItem *item in self.items) {
        item.wxInstance = wxInstance;
    }
    id<WXAMenuProtocol> menu = [WXSDKEngine handlerForProtocol:@protocol(WXAMenuProtocol)];
    if ([menu respondsToSelector:@selector(setWxInstance:)]) {
        [menu setWxInstance:wxInstance];
    }
}

@end
