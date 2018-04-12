//
//  WXAViewControllerUtil.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/20.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXAViewControllerUtil.h"

@implementation WXAViewControllerUtil

+ (UIViewController *)getRootViewController {
    return [self getRootViewControllerLoop:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)getNormalRootViewController {
    UIWindow *topWindow = [self getTopWindow];
    return [self getRootViewControllerLoop:topWindow.rootViewController];
}

+ (UIViewController *)getRootViewControllerLoop:(UIViewController *)rootVC {
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *) rootVC;
        return [self getRootViewControllerLoop:tabBarController.selectedViewController];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *) rootVC;
        return [self getRootViewControllerLoop:navigationController.visibleViewController];
    } else if (rootVC.presentedViewController) {
        UIViewController *presentedViewController = rootVC.presentedViewController;
        return [self getRootViewControllerLoop:presentedViewController];
    } else {
        SEL selector = NSSelectorFromString(@"visibleViewController");
        NSMethodSignature *methodSignature = [rootVC.class methodSignatureForSelector:selector];
        if (methodSignature == nil) {
            return rootVC;
        }
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:rootVC.class];
        [invocation setSelector:selector];
        UIViewController *vc;
        [invocation setReturnValue:&vc];
        [invocation invoke];
        return vc;
    }
}

+ (UIWindow *)getTopWindow {
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (topWindow in windows) {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    return topWindow;
}

@end
