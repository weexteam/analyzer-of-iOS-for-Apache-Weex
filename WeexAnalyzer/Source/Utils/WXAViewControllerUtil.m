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
        typedef UIViewController* (*vcMethod)(id receiver, SEL selector);
        SEL selector = NSSelectorFromString(@"visibleViewController");
        vcMethod mtd = (vcMethod)[[rootVC class] instanceMethodForSelector:selector];
        if (mtd) {
            UIViewController *vc = mtd(rootVC, selector);
            return [self getRootViewControllerLoop:vc];
        } else {
            return rootVC;
        }
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
