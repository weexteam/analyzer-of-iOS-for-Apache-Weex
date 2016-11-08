//
//  WXASwitchSizeOptionView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/6.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXASwitchSizeOptionView.h"
#import "WXAUtility.h"

#define WXALOG_WINDOW_OPTION_HEIGHT         40
#define WXALOG_WINDOW_OPTION_WIDTH          80
#define WXALOG_WINDOW_OPTION_TAG_OFFSET     1000

@interface WXASwitchSizeOptionView ()

@property (nonatomic, strong) NSArray *windowSizes;
@property (nonatomic, strong) NSArray<UIButton *> *btns;
@property (nonatomic, copy) void(^handler)(WXALogWindowType windowType);

@end

@implementation WXASwitchSizeOptionView

- (instancetype)initWithFrame:(CGRect)frame
                   hostOption:(WXAOptionButton *)hostOption
                   windowType:(WXALogWindowType)windowType
                      handler:(void (^)(WXALogWindowType))handler {
    if (self = [super initWithFrame:frame hostOption:hostOption]) {
        _windowType = windowType;
        _windowSizes = @[@"浮窗",@"半屏",@"全屏"];
        _handler = handler;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_windowSizes.count];
    for (NSInteger i = 0; i < _windowSizes.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*WXALOG_WINDOW_OPTION_HEIGHT, WXALOG_WINDOW_OPTION_WIDTH, WXALOG_WINDOW_OPTION_HEIGHT);
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.titleLabel.textColor = [UIColor darkGrayColor];
        btn.tag = WXALOG_WINDOW_OPTION_TAG_OFFSET + i;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeWindow:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:_windowSizes[i] forState:UIControlStateNormal];
        [btn setSelected:[self stringToWindowType:_windowSizes[i]] == _windowType];
        [array addObject:btn];
        [self addSubview:btn];
    }
    _btns = array;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, WXALOG_WINDOW_OPTION_WIDTH, _windowSizes.count*WXALOG_WINDOW_OPTION_HEIGHT);
}

#pragma mark - actions
- (void)changeWindow:(UIButton *)sender {
    NSInteger index = sender.tag - WXALOG_WINDOW_OPTION_TAG_OFFSET;
    _windowType = [self stringToWindowType:_windowSizes[index]];
    
    for (UIButton *btn in _btns) {
        [btn setSelected:[btn isEqual:sender]];
    }
    
    if (self.handler) {
        self.handler(_windowType);
        self.handler = nil;
    }
}

- (WXALogWindowType)stringToWindowType:(NSString *)str {
    if ([@"浮窗" isEqualToString:str]) {
        return WXALogWindowTypeSmall;
    } else if ([@"半屏" isEqualToString:str]) {
        return WXALogWindowTypeMedium;
    } else if ([@"全屏" isEqualToString:str]) {
        return WXALogWindowTypeFullScreen;
    }
    return WXALogWindowTypeMedium;
}

@end
