//
//  WXALogSortBar.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/24.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogSortBar.h"
#import "WXAUtility.h"
#import "WXAUIBuilder.h"

@interface WXALogSortBar () <WXALogLevelFilterDelegate, WXALogWindowFilterDelegate>

@end

@implementation WXALogSortBar

- (instancetype)initWithFrame:(CGRect)frame hostView:(UIView *)hostView settings:(WXALogSettingsModel *)settings {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        self.layer.masksToBounds = YES;
        _hostView = hostView;
        
        [self addItems:settings];

        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        topLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        bottomLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:bottomLine];
    }
    return self;
}

- (void)addItems:(WXALogSettingsModel *)settings {
    CGFloat sortBarHeight = self.frame.size.height;
    CGFloat btnWidth = self.frame.size.width / 6;
    
    // filter
    _logFilter = [[WXALogFilter alloc] initWithFrame:CGRectMake(0, 0, btnWidth, sortBarHeight)
                                                 hostView:_hostView
                                                 hostRect:CGRectMake(0, sortBarHeight, WXA_SCREEN_WIDTH, 0)];
    _logFilter.logLevel = settings.filter.logLevel;
    _logFilter.logFlag = settings.filter.logFlag;
    _logFilter.delegate = self;
    [self addSubview:_logFilter.filterBtn];
    
    UIButton *clearBtn = [WXAUIBuilder logSortBarButtonWithTitle:@"清除" selectedTitle:@"清除"];
    [clearBtn addTarget:self action:@selector(clearLog:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.frame = CGRectMake(btnWidth, 0, btnWidth, sortBarHeight);
    [self addSubview:clearBtn];
    
    UIButton *dragBtn = [WXAUIBuilder logSortBarButtonWithTitle:@"拖拽" selectedTitle:@"拖拽"];
    [dragBtn addTarget:self action:@selector(dragLog:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    dragBtn.frame = CGRectMake(btnWidth*2, 0, btnWidth, sortBarHeight);
    [self addSubview:dragBtn];
    
    UIButton *lockBtn = [WXAUIBuilder logSortBarButtonWithTitle:@"锁定" selectedTitle:@"解锁"];
    [lockBtn addTarget:self action:@selector(lockLog:) forControlEvents:UIControlEventTouchUpInside];
    lockBtn.frame = CGRectMake(btnWidth*3, 0, btnWidth, sortBarHeight);
    [self addSubview:lockBtn];
    
    // window
    _windowFilter = [[WXALogWindowSelect alloc] initWithFrame:CGRectMake(btnWidth*4, 0, btnWidth, sortBarHeight)
                                                     hostView:_hostView
                                                     hostRect:CGRectMake(btnWidth*4, sortBarHeight, 0, 0)];
    _windowFilter.windowType = settings.windowType;
    _windowFilter.delegate = self;
    [self addSubview:_windowFilter.filterBtn];
    
    UIButton *closeBtn = [WXAUIBuilder logSortBarButtonWithTitle:@"关闭" selectedTitle:@"关闭"];
    [closeBtn addTarget:self action:@selector(closeLog:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(btnWidth*5, 0, btnWidth, sortBarHeight);
    [self addSubview:closeBtn];
}

#pragma mark - public methods
- (void)onHostViewSizeChanged {
    CGFloat btnWidth = self.frame.size.width / 6;
    [self.logFilter adjustHostRect:CGRectMake(0, self.frame.size.height, WXA_SCREEN_WIDTH, 0)];
    [self.windowFilter adjustHostRect:CGRectMake(btnWidth*4, self.frame.size.height, 0, 0)];
}

#pragma mark - actions
- (void)clearLog:(UIButton *)sender {
    [self.delegate onClearLog];
}

- (void)dragLog:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:sender] anyObject];
    
    // get delta
    CGPoint previousLocation = [touch previousLocationInView:sender];
    CGPoint location = [touch locationInView:sender];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    // move button
    _hostView.center = CGPointMake(_hostView.center.x + delta_x,_hostView.center.y + delta_y);
}

- (void)lockLog:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.delegate onLockLog];
}

- (void)closeLog:(UIButton *)sender {
    [self.delegate onCloseLog];
}

#pragma mark - WXALogLevelFilterDelegate
- (void)closeAllFloatingLayer {
    [self.logFilter closeFloatingLayer:NO];
    [self.windowFilter closeFloatingLayer:NO];
}

- (void)onLogFilterChanged:(WXLogFlag)logFlag :(WXLogLevel)logLevel {
    WXALogFilterModel *filter = [[WXALogFilterModel alloc] init];
    filter.logFlag = logFlag;
    filter.logLevel = logLevel;
    
    [self.delegate onFilterChanged:filter];
}

#pragma mark - WXALogWindowFilterDelegate
- (void)onWindowSizeChanged:(WXALogWindowType)windowType {
    [self.delegate onWindowTypeChanged:windowType];
}

@end
