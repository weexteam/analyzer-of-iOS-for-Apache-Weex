//
//  WXALogFlagView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogFlagView.h"
#import "WXALogSelectItemView.h"

#define WXALOG_LOGFLAG_ITEM_WIDTH      70
#define WXALOG_LOGFLAG_ITEM_HEIGHT     28
#define WXALOG_LOGFLAG_TAG_OFFSET      100
#define WXALOG_LOGFLAG_ITEM_PADDING    8

@interface WXALogFlagView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray<WXALogSelectItemView *> *btns;
@property (nonatomic, strong) NSArray *logFlags;

@end

@implementation WXALogFlagView

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
    _titleLabel.text = @"日志过滤：";
    [self addSubview:_titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
    [self addSubview:line];
    
    // 选择
    _logFlags = @[@"Error",@"Warning",@"Info",@"Log",@"Debug"];
    NSMutableArray *btns = [NSMutableArray arrayWithCapacity:_logFlags.count];
    for (NSInteger i = 0; i < _logFlags.count; i++) {
        WXALogSelectItemView *btn = [[WXALogSelectItemView alloc] initWithTitle:_logFlags[i] selectedTitle:_logFlags[i]];
        [btn addTarget:self action:@selector(selectLogFlag:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = WXALOG_LOGFLAG_TAG_OFFSET + [self stringToLogFlag:_logFlags[i]];
        [btns addObject:btn];
        [self addSubview:btn];
    }
    _btns = btns;
    [self adjustSubviews];
}

- (void)adjustSubviews {
    CGFloat padding = WXALOG_LOGFLAG_ITEM_PADDING;
    CGFloat x = 0;
    CGFloat y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10;
    for (UIButton *btn in _btns) {
        btn.frame = CGRectMake(x, y, WXALOG_LOGFLAG_ITEM_WIDTH, WXALOG_LOGFLAG_ITEM_HEIGHT);
        
        x += WXALOG_LOGFLAG_ITEM_WIDTH + padding;
        if (x + WXALOG_LOGFLAG_ITEM_WIDTH > self.frame.size.width) {
            x = 0;
            y += padding + WXALOG_LOGFLAG_ITEM_HEIGHT;
        }
    }
    
    CGFloat height = (_btns.count > 0 ? ([_btns lastObject].frame.origin.y + [_btns lastObject].frame.size.height) + 10 : y);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

#pragma mark - actions
- (void)selectLogFlag:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    NSInteger logFlag = 0;
    for (UIButton *btn in _btns) {
        WXLogFlag flag = btn.tag - WXALOG_LOGFLAG_TAG_OFFSET;
        if (btn.selected) {
            logFlag = logFlag | flag;
        }
    }
    _logFlag = logFlag;
}

- (void)setLogFlag:(NSInteger)logFlag {
    _logFlag = logFlag;
    
    for (UIButton *btn in _btns) {
        [btn setSelected:(btn.tag - WXALOG_LOGFLAG_TAG_OFFSET) & logFlag];
    }
}

- (WXLogFlag)stringToLogFlag:(NSString *)str {
    if ([@"Error" isEqualToString:str]) {
        return WXLogFlagError;
    } else if ([@"Warning" isEqualToString:str]) {
        return WXLogFlagWarning;
    } else if ([@"Info" isEqualToString:str]) {
        return WXLogFlagInfo;
    } else if ([@"Log" isEqualToString:str]) {
        return WXLogFlagLog;
    } else if ([@"Debug" isEqualToString:str]) {
        return WXLogFlagDebug;
    }
    return WXLogFlagDebug;
}

- (NSString *)logFlagToStr:(WXLogFlag)flag {
    switch (flag) {
        case WXLogFlagError:
            return @"Error";
            break;
        case WXLogFlagWarning:
            return @"Warning";
            break;
        case WXLogFlagInfo:
            return @"Info";
            break;
        case WXLogFlagLog:
            return @"Log";
            break;
        case WXLogFlagDebug:
            return @"Debug";
            break;
        default:
            return nil;
            break;
    }
}

@end
