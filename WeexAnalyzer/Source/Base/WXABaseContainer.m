//
//  WXABaseContainer.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXABaseContainer.h"
#import "WXAUtility.h"
#import "UIView+WXAPopover.h"
#import "WXASwitchSizeOptionView.h"

#define WXA_OPTIONBAR_HEIGHT   40

@interface WXABaseContainer () <WXABaseOptionBarDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) WXAOptionBaseView *optionView;

@end

@implementation WXABaseContainer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.optionBar];
        [self addSubview:self.contentView];
    }
    return self;
}

#pragma mark - public methods
- (void)show {
    __weak typeof(self) welf = self;
    [self WeexAnalyzer_popover:^{
        welf.transform = CGAffineTransformMakeTranslation(0, welf.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            welf.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)showOptionView:(WXAOptionBaseView *)optionView {
    [self closeOptionView:NO];
    
    self.optionView = optionView;
    self.optionView.hostOption.selected = YES;
    CGRect frame = optionView.frame;
    optionView.frame = CGRectMake(frame.origin.x, _contentView.frame.origin.y, frame.size.width, 0);
    
    self.maskView.alpha = 0;
    optionView.hidden = NO;
    self.maskView.hidden = NO;
    [self addSubview:optionView];
    [self insertSubview:self.maskView belowSubview:optionView];
    
    [UIView animateWithDuration:0.2 animations:^{
        optionView.frame = frame;
        self.maskView.alpha = 0.3;
    }];
}

- (void)closeOptionView:(BOOL)animated {
    [self.optionBar clearOptionSelected];
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = _optionView.frame;
            _optionView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
            _maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [_optionView removeFromSuperview];
            _optionView = nil;
            [_maskView removeFromSuperview];
            _maskView = nil;
        }];
    } else {
        [_optionView removeFromSuperview];
        _optionView = nil;
        [_maskView removeFromSuperview];
        _maskView = nil;
    }
}

#pragma mark - actions
- (void)maskCloseFloatingLayer:(UITapGestureRecognizer *)tap {
    [self closeOptionView:YES];
}

- (void)switchSize:(WXALogWindowType)windowType {
    
}

#pragma mark - WXABaseOptionBarDelegate
- (void)onCloseContainer {
    [self hide];
    [self.delegate onCloseWindow];
}

- (void)onShowSwitchSize:(WXAOptionButton *)sender {
    if (sender.selected) {
        [self closeOptionView:YES];
        return;
    }
    
    __weak typeof(self) welf = self;
    WXASwitchSizeOptionView *optionView = [[WXASwitchSizeOptionView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, 0, 0, 0)
                                                                              hostOption:sender
                                                                              windowType:WXALogWindowTypeMedium
                                                                                 handler:^(WXALogWindowType windowType) {
                                                                                     [welf closeOptionView:YES];
                                                                                     [welf switchSize:windowType];
                                                                                 }];
    [self showOptionView:optionView];
}

- (void)onChangePosition:(CGPoint)point {
    self.center = CGPointMake(self.center.x + point.x, self.center.y + point.y);
}

#pragma mark - Getters
- (WXABaseOptionBar *)optionBar {
    if (!_optionBar) {
        _optionBar = [[WXABaseOptionBar alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, WXA_OPTIONBAR_HEIGHT)];
        _optionBar.delegate = self;
    }
    return _optionBar;
}

- (WXABaseContentView *)contentView {
    if (!_contentView) {
        _contentView = [[WXABaseContentView alloc] initWithFrame:CGRectMake(0, WXA_OPTIONBAR_HEIGHT, WXA_SCREEN_WIDTH, self.frame.size.height-WXA_OPTIONBAR_HEIGHT)];
    }
    return _contentView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:_contentView.frame];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
        _maskView.hidden = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskCloseFloatingLayer:)];
        [_maskView addGestureRecognizer:tapGesture];
    }
    return _maskView;
}

+ (CGRect)frameForWindowType:(WXALogWindowType)windowType {
    switch (windowType) {
            case WXALogWindowTypeSmall:
            return CGRectMake(WXA_SCREEN_WIDTH - 110, WXA_SCREEN_HEIGHT/2, 100, 30);
            case WXALogWindowTypeMedium:
            return CGRectMake(0, WXA_SCREEN_HEIGHT-(WXA_SCREEN_HEIGHT/2), WXA_SCREEN_WIDTH, WXA_SCREEN_HEIGHT/2);
            case WXALogWindowTypeFullScreen:
            return CGRectMake(0, 64, WXA_SCREEN_WIDTH, WXA_SCREEN_HEIGHT-64);
        default:
            return CGRectMake(0, WXA_SCREEN_HEIGHT-(WXA_SCREEN_HEIGHT/2), WXA_SCREEN_WIDTH, WXA_SCREEN_HEIGHT/2);
    }
}

@end
