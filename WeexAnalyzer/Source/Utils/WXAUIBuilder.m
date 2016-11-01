//
//  WXAUIBuilder.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXAUIBuilder.h"

@implementation WXAUIBuilder

+ (UIButton *)logSortBarButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:selectedTitle forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    return btn;
}

@end
