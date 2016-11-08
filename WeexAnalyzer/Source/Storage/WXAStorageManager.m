//
//  WXAStorageManager.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAStorageManager.h"
#import <UIKit/UIKit.h>
#import "UIView+WXAPopover.h"
#import "WXAStorageContainer.h"
#import "WXAUtility.h"

@interface WXAStorageManager () <WXABaseContainerDelegate>

@property (nonatomic, strong) WXAStorageContainer *container;

@end

@implementation WXAStorageManager

- (WXAMenuItem *)mItem {
    if (!_mItem) {
        _mItem = [[WXAMenuItem alloc] init];
        _mItem.title = @"Weex-Storage管理";
        __weak typeof(self) welf = self;
        _mItem.handler = ^(BOOL selected) {
            if (selected) {
                [welf show];
            } else {
                [welf hide];
            }
        };
    }
    return _mItem;
}

#pragma mark - public methods
- (void)free {
    [self hide];
}

- (void)show {
    [self.container show];
    [self showStorageList];
}

- (void)hide {
    [_container hide];
    _container = nil;
}

#pragma mark - actions
- (void)showStorageList {
    [self.container refreshData];
}

#pragma mark - WXABaseContainerDelegate
- (void)onCloseWindow {
    [self hide];
}

#pragma mark - Setters
- (WXAStorageContainer *)container {
    if (!_container) {
        _container = [[WXAStorageContainer alloc] initWithFrame:CGRectMake(0,64,WXA_SCREEN_WIDTH,WXA_SCREEN_HEIGHT-64)];
        _container.backgroundColor = [UIColor whiteColor];
        _container.delegate = self;
    }
    return _container;
}

@end
