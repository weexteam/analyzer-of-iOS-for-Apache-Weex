//
//  WXAMenuItem.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXAMenuItem.h"
#import "WXAUtility.h"

@implementation WXAMenuItem

- (void)show: (UIViewController *)controller {
    if (!_window) {
        _window = [UIWindow new];
    }
    _window.rootViewController = controller;
    _window.windowLevel = UIWindowLevelAlert+1000;
    _window.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _window.userInteractionEnabled = YES;
    _window.hidden = NO;
    [_window makeKeyAndVisible];
}

@end
