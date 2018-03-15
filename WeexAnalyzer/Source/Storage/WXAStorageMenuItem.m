//
//  WXAStorageMenuItem.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/29.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAStorageMenuItem.h"
#import "WXAStorageManager.h"

@interface WXAStorageMenuItem ()

@property (nonatomic, strong) WXAStorageManager *manager;

@end

@implementation WXAStorageMenuItem

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Storage";
        self.iconImage = [UIImage imageNamed:@"wxt_icon_storage"];
        
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

- (void)dealloc {
    [_manager free];
}

#pragma mark - Getters
- (WXAStorageManager *)manager {
    if (!_manager) {
        _manager = [[WXAStorageManager alloc] init];
    }
    return _manager;
}

@end
