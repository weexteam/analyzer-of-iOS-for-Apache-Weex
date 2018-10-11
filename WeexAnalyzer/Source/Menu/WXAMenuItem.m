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
    [WXAWindow sharedInstance].hidden = NO;
    
    
    naviController.view.frame = CGRectMake(0, 88, naviController.view.frame.size.width, naviController.view.frame.size.height);
    __weak UINavigationController *weakNaviController = naviController;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakNaviController.view.frame = CGRectMake(0, 0, weakNaviController.view.frame.size.width, weakNaviController.view.frame.size.height);
    } completion:nil];
    
}

@end
