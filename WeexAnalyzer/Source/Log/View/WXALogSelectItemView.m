//
//  WXALogSelectItemView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogSelectItemView.h"

@implementation WXALogSelectItemView

- (instancetype)initWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle {
    if (self = [self init]) {
        [self setTitle:title forState:UIControlStateNormal];
        if (selectedTitle) {
            [self setTitle:selectedTitle forState:UIControlStateSelected];
        }
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.backgroundColor = !selected ? [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] : [UIColor orangeColor];
}

@end
