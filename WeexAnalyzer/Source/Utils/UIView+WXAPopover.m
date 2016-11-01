//
//  UIView+WXAPopover.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/20.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "UIView+WXAPopover.h"
#import "WXAViewControllerUtil.h"

@implementation UIView (WXAPopover)

- (void)WeexAnalyzer_popover:(dispatch_block_t)animationBlock {
    UIWindow *topWindow = [WXAViewControllerUtil getTopWindow];
    [self WeexAnalyzer_popoverIn:topWindow animationBlock:animationBlock];
}

- (void)WeexAnalyzer_popoverIn:(UIView *)parentView animationBlock:(dispatch_block_t)animationBlock {
    if (self.superview) {
        [self removeFromSuperview];
    }
    [parentView addSubview:self];
    
    if (animationBlock) {
        animationBlock();
    }
}

@end
