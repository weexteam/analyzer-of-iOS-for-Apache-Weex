//
//  UIView+WXAPopover.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/20.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WXAPopover)

- (void)WeexAnalyzer_popover:(dispatch_block_t)animationBlock;
- (void)WeexAnalyzer_popoverIn:(UIView *)parentView animationBlock:(dispatch_block_t)animationBlock;

@end
