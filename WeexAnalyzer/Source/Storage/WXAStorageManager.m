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
        _container = [[WXAStorageContainer alloc] initWithWindowType:WXALogWindowTypeMedium];
        _container.delegate = self;
    }
    return _container;
}

@end
