//
//  WXAMenuItem.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXAMenuItem.h"
#import "WXAUtility.h"
#import "WXAViewControllerUtil.h"
#import "WXAUtility.h"
#import "WXAWindow.h"

@implementation WXAMenuItem

- (void)open:(BOOL)selected {
    if (_handler) {
        _handler(selected);
    }
    if(_controllerClass) {
        UIViewController* controller =  [_controllerClass new];
        [self show:controller];
    }
}

- (void)show:(UIViewController *)controller {
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
    naviController.navigationBar.backgroundColor = nil;
    naviController.navigationBarHidden = YES;
    [WXAWindow sharedInstance].rootViewController = naviController;
    [[WXAWindow sharedInstance] makeKeyAndVisible];
}

- (void)closeItem:(id)sender {
    [WXAWindow sharedInstance].hidden = YES;
    [[WXAWindow sharedInstance] resignKeyWindow];
}

@end
