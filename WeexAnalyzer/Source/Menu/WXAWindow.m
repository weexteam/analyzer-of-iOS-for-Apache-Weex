//
//  WXAWindow.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/4/10.
//

#import "WXAWindow.h"
#import "WXABaseViewController.h"
#import "WXAMenuView.h"

@implementation WXAWindow

+ (instancetype)sharedInstance {
    static WXAWindow *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [self new];
        instance.windowLevel = UIWindowLevelAlert-2;
        instance.backgroundColor = nil;
    });
    return instance;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.rootViewController && [self.rootViewController isKindOfClass:UINavigationController.class]) {
        WXABaseViewController *vc = (WXABaseViewController *)((UINavigationController *)self.rootViewController).topViewController;
        if ([vc respondsToSelector:@selector(pointInside:withEvent:)]) {
            if ([vc pointInside:point withEvent:event]) {
                return [super hitTest:point withEvent:event];
            }
        } else {
            return [super hitTest:point withEvent:event];
        }
    }
    if ([[self viewWithTag:WXAMenuItemTag] isKindOfClass:WXAMenuView.class]) {
        return [[self viewWithTag:WXAMenuItemTag] hitTest:point withEvent:event];
    }
    return nil;
}

@end
