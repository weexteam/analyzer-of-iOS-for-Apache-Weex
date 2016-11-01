//
//  WXALogWindowSelect.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/26.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#define WXALOG_WINDOW_OPTION_HEIGHT         40
#define WXALOG_WINDOW_OPTION_WIDTH          80
#define WXALOG_WINDOW_OPTION_TAG_OFFSET     1000

#import "WXALogWindowSelect.h"
#import "WXAUIBuilder.h"

@interface WXALogWindowSelect ()

@property (nonatomic, weak) UIView *hostView;
@property (nonatomic, assign) CGRect hostRect;
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, strong) UIView *filterView;

@property (nonatomic, strong) UIView *filterOptionsView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) NSArray *windowSizes;
@property (nonatomic, strong) NSArray<UIButton *> *btns;

@end

@implementation WXALogWindowSelect

- (instancetype)initWithFrame:(CGRect)frame hostView:(UIView *)hostView hostRect:(CGRect)hostRect {
    if (self = [super init]) {
        _hostView = hostView;
        _hostRect = hostRect;
        _frame = frame;
        _windowSizes = @[@"浮窗",@"半屏",@"全屏"];
    }
    return self;
}

- (UIButton *)filterBtn {
    if (!_filterBtn) {
        _filterBtn = [WXAUIBuilder logSortBarButtonWithTitle:@"窗口 ↓" selectedTitle:@"窗口 ↑"];
        _filterBtn.frame = self.frame;
        [_filterBtn addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
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

- (UIView *)filterOptionsView {
    if (!_filterOptionsView) {
        _filterOptionsView = [[UIView alloc] initWithFrame:CGRectMake(_hostRect.origin.x, _hostRect.origin.y, WXALOG_WINDOW_OPTION_WIDTH, WXALOG_WINDOW_OPTION_HEIGHT*_windowSizes.count)];
        _filterOptionsView.backgroundColor = [UIColor whiteColor];
        _filterOptionsView.clipsToBounds = YES;
        
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
            [array addObject:btn];
            [_filterOptionsView addSubview:btn];
        }
        _btns = array;
    }
    return _filterOptionsView;
}

#pragma mark - actions
- (void)changeWindow:(UIButton *)sender {
    NSInteger index = sender.tag - WXALOG_WINDOW_OPTION_TAG_OFFSET;
    _windowType = [self stringToWindowType:_windowSizes[index]];
    
    for (UIButton *btn in _btns) {
        [btn setSelected:[btn isEqual:sender]];
    }

    _filterBtn.selected = NO;
    [self closeFloatingLayer:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onWindowSizeChanged:)]) {
        [self.delegate onWindowSizeChanged:_windowType];
    }
}

- (void)setWindowType:(WXALogWindowType)windowType {
    _windowType = windowType;
    
    for (UIButton *btn in _btns) {
        NSInteger index = btn.tag - WXALOG_WINDOW_OPTION_TAG_OFFSET;
        WXALogWindowType windowType = [self stringToWindowType:_windowSizes[index]];
        [btn setSelected:windowType == _windowType];
    }
}

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
    self.maskView.alpha = 0;
    self.filterOptionsView.hidden = NO;
    self.maskView.hidden = NO;
    [_hostView addSubview:self.filterOptionsView];
    [_hostView insertSubview:self.maskView belowSubview:self.filterOptionsView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.filterOptionsView.frame = CGRectMake(_hostRect.origin.x, _hostRect.origin.y, WXALOG_WINDOW_OPTION_WIDTH, WXALOG_WINDOW_OPTION_HEIGHT*_windowSizes.count);
        self.maskView.alpha = 0.3;
    }];
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

- (void)maskCloseFloatingLayer:(id)sender {
    _filterBtn.selected = NO;
    [self closeFloatingLayer:YES];
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

- (void)adjustHostRect:(CGRect)hostRect {
    _hostRect = hostRect;
    _maskView.frame = CGRectMake(0, _hostRect.origin.y, _hostView.frame.size.width, _hostView.frame.size.height-_hostRect.origin.y);
}

@end
