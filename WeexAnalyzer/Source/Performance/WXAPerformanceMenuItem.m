//
//  WXAPerformanceMenuItem.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/29.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAPerformanceMenuItem.h"
#import "WXAPerformanceManager.h"

@interface WXAPerformanceMenuItem ()

@property (nonatomic, strong) WXAPerformanceManager *manager;

@end

@implementation WXAPerformanceMenuItem

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"性能指标";
        self.iconImage = [UIImage imageNamed:@"wxt_icon_performance"];
        __weak typeof(self) welf = self;
        self.handler = ^(BOOL selected) {
            if (selected) {
                [welf.manager show];
            } else {
                [welf.manager hide];
            }
        };
    }
    return self;
}

- (void)setWxInstance:(WXSDKInstance *)wxInstance {
    [super setWxInstance:wxInstance];
    self.manager.wxInstance = wxInstance;
}

- (void)dealloc {
    [_manager free];
}

#pragma mark - Getters
- (WXAPerformanceManager *)manager {
    if (!_manager) {
        _manager = [[WXAPerformanceManager alloc] init];
        _manager.wxInstance = self.wxInstance;
    }
    return _manager;
}

@end
