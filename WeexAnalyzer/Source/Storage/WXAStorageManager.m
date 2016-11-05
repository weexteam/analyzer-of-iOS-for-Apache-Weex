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

@interface WXAStorageManager () <WXAStorageContainerDelegate>

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
    
}

- (void)show {
    __weak typeof(self) welf = self;
    [self.container WeexAnalyzer_popover:^{
        welf.container.transform = CGAffineTransformMakeTranslation(0, welf.container.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            welf.container.transform = CGAffineTransformIdentity;
        }];
    }];
    [self showStorageList];
}

- (void)hide {
    [_container removeFromSuperview];
    _container = nil;
}

#pragma mark - actions
- (void)showStorageList {
    [self.container refreshData];
}

#pragma mark - WXAStorageContainerDelegate
- (void)onCloseWindow {
    [self hide];
}

#pragma mark - Setters
- (WXAStorageContainer *)container {
    if (!_container) {
        _container = [[WXAStorageContainer alloc] initWithFrame:CGRectMake(0,20,WXA_SCREEN_WIDTH,WXA_SCREEN_HEIGHT-20)];
        _container.backgroundColor = [UIColor whiteColor];
        _container.delegate = self;
    }
    return _container;
}

@end
