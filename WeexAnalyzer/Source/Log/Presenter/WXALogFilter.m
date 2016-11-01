//
//  WXALogFilter.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/24.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogFilter.h"
#import "WXALogFilterView.h"
#import "WXAUIBuilder.h"

#define WXALOG_OPTIONS_VIEW_HEIGHT  250

@interface WXALogFilter () <WXALogFilterViewDelegate>

@property (nonatomic, weak) UIView *hostView;
@property (nonatomic, assign) CGRect hostRect;
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, strong) WXALogFilterView *filterOptionsView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation WXALogFilter

- (instancetype)initWithFrame:(CGRect)frame hostView:(UIView *)hostView hostRect:(CGRect)hostRect {
    if (self = [super init]) {
        _hostView = hostView;
        _hostRect = hostRect;
        _frame = frame;
    }
    return self;
}

#pragma mark - actions
- (void)filterClicked:(UIButton *)sender {
    if (!_filterBtn.selected) {
        [self openFloatingLayer];
    } else {
        [self closeFloatingLayer:YES];
    }
    
    _filterBtn.selected = !_filterBtn.selected;
}

- (void)openFloatingLayer {
    [self.delegate closeAllFloatingLayer];
    
    CGRect frame = self.filterOptionsView.frame;
    self.filterOptionsView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
    [self.filterOptionsView setLogFilter:_logFlag :_logLevel];
    self.filterOptionsView.logFlagView.logFlag = _logFlag;
    [self.filterOptionsView.container setContentOffset:CGPointMake(0, 0) animated:NO];
    self.maskView.alpha = 0;
    self.filterOptionsView.hidden = NO;
    self.maskView.hidden = NO;
    [_hostView addSubview:self.filterOptionsView];
    [_hostView insertSubview:self.maskView belowSubview:self.filterOptionsView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.filterOptionsView.frame = CGRectMake(_hostRect.origin.x, _hostRect.origin.y, _hostRect.size.width, WXALOG_OPTIONS_VIEW_HEIGHT);
        self.maskView.alpha = 0.3;
    }];
}

- (void)maskCloseFloatingLayer:(id)sender {
    _filterBtn.selected = NO;
    [self closeFloatingLayer:YES];
}

#pragma mark - public methods
- (void)adjustHostRect:(CGRect)hostRect {
    _hostRect = hostRect;
    _maskView.frame = CGRectMake(0, _hostRect.origin.y, _hostView.frame.size.width, _hostView.frame.size.height-_hostRect.origin.y);
}

- (void)closeFloatingLayer:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = _filterOptionsView.frame;
            _filterOptionsView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
            _maskView.alpha = 0;
        } completion:^(BOOL finished) {
            _filterOptionsView.hidden = YES;
            _maskView.hidden = YES;
            [_filterOptionsView removeFromSuperview];
            [_maskView removeFromSuperview];
        }];
    } else {
        CGRect frame = _filterOptionsView.frame;
        _filterOptionsView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
        _maskView.alpha = 0;
        _filterOptionsView.hidden = YES;
        _maskView.hidden = YES;
        [_filterOptionsView removeFromSuperview];
        [_maskView removeFromSuperview];
    }
}

#pragma mark - WXALogFilterViewDelegate
- (void)onLogFilterChanged:(WXLogFlag)logFlag :(WXLogLevel)logLevel {
    _logFlag = logFlag;
    _logLevel = logLevel;
    _filterBtn.selected = NO;
    [self closeFloatingLayer:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLogFilterChanged::)]) {
        [self.delegate onLogFilterChanged:logFlag :logLevel];
    }
}

#pragma mark - Setters
- (UIButton *)filterBtn {
    if (!_filterBtn) {
        _filterBtn = [WXAUIBuilder logSortBarButtonWithTitle:@"筛选 ↓" selectedTitle:@"筛选 ↑"];
        _filterBtn.frame = self.frame;
        [_filterBtn addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}

- (WXALogFilterView *)filterOptionsView {
    if (!_filterOptionsView) {
        _filterOptionsView = [[WXALogFilterView alloc] initWithFrame:CGRectMake(_hostRect.origin.x, _hostRect.origin.y, _hostRect.size.width, WXALOG_OPTIONS_VIEW_HEIGHT)];
        _filterOptionsView.backgroundColor = [UIColor whiteColor];
        _filterOptionsView.clipsToBounds = YES;
        _filterOptionsView.delegate = self;
    }
    return _filterOptionsView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, _hostRect.origin.y, _hostView.frame.size.width, _hostView.frame.size.height-_hostRect.origin.y)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
        _maskView.hidden = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskCloseFloatingLayer:)];
        [_maskView addGestureRecognizer:tapGesture];
    }
    return _maskView;
}

@end
