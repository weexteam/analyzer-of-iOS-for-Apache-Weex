//
//  WXAStorageBar.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAStorageBar.h"
#import "WXAUIBuilder.h"

@interface WXAStorageBar ()

@end

@implementation WXAStorageBar

- (instancetype)initWithFrame:(CGRect)frame hostView:(UIView *)hostView {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        self.layer.masksToBounds = YES;
        _hostView = hostView;
        
        [self addItems];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        topLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        bottomLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:bottomLine];
    }
    return self;
}

- (void)addItems {
    CGFloat sortBarHeight = self.frame.size.height;
    CGFloat btnWidth = self.frame.size.width / 6;
    
    UIButton *refreshBtn = [WXAUIBuilder logSortBarButtonWithTitle:@"刷新" selectedTitle:@"刷新"];
    [refreshBtn addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventTouchDragInside];
    refreshBtn.frame = CGRectMake(btnWidth*0, 0, btnWidth, sortBarHeight);
    [self addSubview:refreshBtn];
    
    UIButton *clearBtn = [WXAUIBuilder logSortBarButtonWithTitle:@"清空" selectedTitle:@"清空"];
    [clearBtn addTarget:self action:@selector(clearAll:) forControlEvents:UIControlEventTouchDragInside];
    clearBtn.frame = CGRectMake(btnWidth*1, 0, btnWidth, sortBarHeight);
    [self addSubview:clearBtn];
    
    UIButton *dragBtn = [WXAUIBuilder logSortBarButtonWithTitle:@"拖拽" selectedTitle:@"拖拽"];
    [dragBtn addTarget:self action:@selector(dragLog:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    dragBtn.frame = CGRectMake(btnWidth*2, 0, btnWidth, sortBarHeight);
    [self addSubview:dragBtn];
    
    UIButton *closeBtn = [WXAUIBuilder logSortBarButtonWithTitle:@"关闭" selectedTitle:@"关闭"];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(btnWidth*5, 0, btnWidth, sortBarHeight);
    [self addSubview:closeBtn];
}

#pragma mark - public methods
- (void)onHostViewSizeChanged {
}

#pragma mark - actions
- (void)refreshData {
    [self.delegate refreshAll];
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

- (void)close:(UIButton *)sender {
    [self.delegate onCloseWindow];
}

- (void)clearAll:(UIButton *)sender {
    [self.delegate clearAll];
}

@end
