//
//  WXAOptionBaseView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/8.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAOptionBaseView.h"

@implementation WXAOptionBaseView

- (instancetype)initWithFrame:(CGRect)frame hostOption:(WXAOptionButton *)hostOption {
    if (self = [super initWithFrame:frame]) {
        _hostOption = hostOption;
    }
    return self;
}

@end
