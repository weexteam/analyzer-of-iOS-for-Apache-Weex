//
//  WXALogLevelView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogLevelView.h"
#import "WXALogSelectItemView.h"

#define WXALOG_LOGLEVEL_ITEM_WIDTH      70
#define WXALOG_LOGLEVEL_ITEM_HEIGHT     28
#define WXALOG_LOGLEVEL_TAG_OFFSET      100
#define WXALOG_LOGLEVEL_ITEM_PADDING    8

@interface WXALogLevelView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray<WXALogSelectItemView *> *btns;
@property (nonatomic, strong) NSArray *logLevels;

@end

@implementation WXALogLevelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    // 标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.text = @"日志输出级别：";
    [self addSubview:_titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
    [self addSubview:line];
    
    // 选择
    _logLevels = @[@"Error",@"Warning",@"Info",@"Log",@"Debug",@"All"];
    NSMutableArray *btns = [NSMutableArray arrayWithCapacity:_logLevels.count];
    for (NSInteger i = 0; i < _logLevels.count; i++) {
        WXALogSelectItemView *btn = [[WXALogSelectItemView alloc] initWithTitle:_logLevels[i] selectedTitle:_logLevels[i]];
        [btn addTarget:self action:@selector(selectLogLevel:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = WXALOG_LOGLEVEL_TAG_OFFSET + [self stringToLogLevel:_logLevels[i]];
        [btns addObject:btn];
        [self addSubview:btn];
    }
    _btns = btns;
    [self adjustSubviews];
}

- (void)adjustSubviews {
    CGFloat padding = WXALOG_LOGLEVEL_ITEM_PADDING;
    CGFloat x = 0;
    CGFloat y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height+10;
    for (UIButton *btn in _btns) {
        btn.frame = CGRectMake(x, y, WXALOG_LOGLEVEL_ITEM_WIDTH, WXALOG_LOGLEVEL_ITEM_HEIGHT);
        
        x += WXALOG_LOGLEVEL_ITEM_WIDTH + padding;
        if (x + WXALOG_LOGLEVEL_ITEM_WIDTH > self.frame.size.width) {
            x = 0;
            y += padding + WXALOG_LOGLEVEL_ITEM_HEIGHT;
        }
    }
    
    CGFloat height = (_btns.count > 0 ? ([_btns lastObject].frame.origin.y + [_btns lastObject].frame.size.height)+10 : y);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

#pragma mark - actions
- (void)selectLogLevel:(UIButton *)sender {
    _logLevel = sender.tag - WXALOG_LOGLEVEL_TAG_OFFSET;
    
    for (UIButton *btn in _btns) {
        [btn setSelected:[btn isEqual:sender]];
    }
}

- (void)setLogLevel:(WXLogLevel)logLevel {
    _logLevel = logLevel;

    for (UIButton *btn in _btns) {
        [btn setSelected:btn.tag == _logLevel + WXALOG_LOGLEVEL_TAG_OFFSET];
    }
}

- (WXLogLevel)stringToLogLevel:(NSString *)str {
    if ([@"Error" isEqualToString:str]) {
        return WXLogLevelError;
    } else if ([@"Warning" isEqualToString:str]) {
        return WXLogLevelWarning;
    } else if ([@"Info" isEqualToString:str]) {
        return WXLogLevelInfo;
    } else if ([@"Log" isEqualToString:str]) {
        return WXLogLevelLog;
    } else if ([@"Debug" isEqualToString:str]) {
        return WXLogLevelDebug;
    } else if ([@"All" isEqualToString:str]) {
        return WXLogLevelAll;
    }
    return WXLogLevelLog;
}

- (NSString *)logLevelToStr:(WXLogLevel)level {
    switch (level) {
        case WXLogLevelError:
            return @"Error";
            break;
        case WXLogLevelWarning:
            return @"Warning";
            break;
        case WXLogLevelInfo:
            return @"Info";
            break;
        case WXLogLevelLog:
            return @"Log";
            break;
        case WXLogLevelDebug:
            return @"Debug";
            break;
        case WXLogLevelAll:
            return @"All";
            break;
        default:
            return @"All";
            break;
    }
}

@end
