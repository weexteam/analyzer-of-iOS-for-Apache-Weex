//
//  WXABaseOptionBar.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXABaseOptionBar.h"

@interface WXABaseOptionBar ()

@property (nonatomic, strong) NSMutableArray *optionList;

@end

@implementation WXABaseOptionBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _optionList = [NSMutableArray array];
        _autoAdjustOptionWidth = YES;
        _padding = 0;
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        self.clipsToBounds = YES;
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        topLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        bottomLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:bottomLine];
    }
    return self;
}

- (void)addOption:(WXAOptionButton *)option {
    if (!option) {
        return;
    }
    
    [self addSubview:option];
    [self.optionList addObject:option];
}

- (void)clearOptionSelected {
    for (UIButton *button in _optionList) {
        [button setSelected:NO];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.autoAdjustOptionWidth) {
        CGFloat optionWidth = (self.frame.size.width - (_optionList.count-1)*_padding)/_optionList.count;
        CGFloat x = 0;
        for (WXAOptionButton *option in _optionList) {
            option.frame = CGRectMake(x, 1, optionWidth, self.frame.size.height-2);
            x += _padding + optionWidth;
        }
    } else {
        CGFloat x = 0;
        for (WXAOptionButton *option in _optionList) {
            CGFloat optionWidth = option.frame.size.width;
            if (optionWidth == 0) {
                [option sizeToFit];
                optionWidth = option.frame.size.width;
            }
            option.frame = CGRectMake(x, 1, optionWidth, self.frame.size.height-2);
            x += _padding + optionWidth;
        }
    }
}

- (void)addDefaultOption:(WXADefaultOptionType)optionType {
    __weak typeof(self) welf = self;
    WXAOptionButton *option;
    
    switch (optionType) {
        case WXADefaultOptionTypeCloseWindow:
        {
            option = [[WXAOptionButton alloc] initWithTitle:@"关闭"
                                              selectedTitle:@"关闭"
                                               clickHandler:^(UIButton *button) {
                                                   [welf.delegate onCloseContainer];
                                               } dragHandler:nil];
        }
            break;
        case WXADefaultOptionTypeSwitchSize:
        {
            option = [[WXAOptionButton alloc] initWithTitle:@"窗口 ↓"
                                              selectedTitle:@"窗口 ↑"
                                               clickHandler:^(UIButton *button) {
                                                   [welf.delegate onShowSwitchSize:button];
                                               } dragHandler:nil];
        }
            break;
        case WXADefaultOptionTypeDrag:
        {
            option = [[WXAOptionButton alloc] initWithTitle:@"拖拽"
                                                dragHandler:^(UIButton *button, CGPoint point) {
                                                    [welf.delegate onChangePosition:point];
                                                }];
        }
        default:
            break;
    }
    
    if (option) {
        [self addOption:option];
    }
}

@end
