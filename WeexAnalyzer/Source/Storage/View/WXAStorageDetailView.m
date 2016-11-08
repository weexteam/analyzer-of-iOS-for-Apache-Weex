//
//  WXAStorageDetailView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/3.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAStorageDetailView.h"
#import "UIView+WXAPopover.h"
#import "WXAUtility.h"

#define WXASTORAGE_DETAIL_TOOLBAR_HEIGHT    40.0f

@interface WXAStorageDetailView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UIScrollView *container;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *copyButton;
@property (nonatomic, strong) UIButton *okButton;

@end

@implementation WXAStorageDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.maskView];
        [self addSubview:self.panel];
    }
    return self;
}

- (void)setItemValue:(NSString *)itemValue {
    _itemValue = itemValue;
    
    _textLabel.text = itemValue;
    NSDictionary *attribute = @{NSFontAttributeName: _textLabel.font};
    CGSize size = [itemValue boundingRectWithSize:CGSizeMake(_textLabel.frame.size.width, 1000)
                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    _textLabel.frame = CGRectMake(_textLabel.frame.origin.x, _textLabel.frame.origin.y, _textLabel.frame.size.width, size.height);
    _container.contentSize = CGSizeMake(_container.frame.size.width, _textLabel.frame.size.height + 20);
}

#pragma mark - public methods
- (void)showInView:(UIView *)parentView {
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    __weak typeof(self) welf = self;
    [self WeexAnalyzer_popoverIn:parentView animationBlock:^{
        welf.maskView.alpha = 0;
        welf.panel.frame = CGRectMake(welf.panel.frame.origin.x, WXA_SCREEN_HEIGHT, welf.panel.frame.size.width, welf.panel.frame.size.height);
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            welf.panel.frame = CGRectMake(50, 120, self.frame.size.width - 100, self.frame.size.height-240);
            welf.maskView.alpha = 0.5;
        } completion:nil];
    }];
}

#pragma mark - actions
- (void)copyText:(id)sender {
    NSString *itemValue = _itemValue;
    if (itemValue && [itemValue isKindOfClass:[NSString class]] && itemValue.length > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];//黏贴板
            [pasteBoard setString:itemValue];
        });
    }
}

- (void)closeWindow:(id)sender {
    [self removeFromSuperview];
    [self.delegate onCloseDetailWindow];
}

- (void)maskCloseWindow {
    [self closeWindow:nil];
}

#pragma mark - Setters
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskCloseWindow)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)panel {
    if (!_panel) {
        _panel = [[UIView alloc] initWithFrame:CGRectMake(50, 120, self.frame.size.width - 100, self.frame.size.height-240)];
        _panel.backgroundColor = [UIColor whiteColor];
        _panel.layer.cornerRadius = 5;
        _panel.layer.masksToBounds = YES;
        
        [_panel addSubview:self.container];
        [_panel addSubview:self.toolBar];
    }
    return _panel;
}

- (UIScrollView *)container {
    if (!_container) {
        _container = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _panel.frame.size.width, _panel.frame.size.height-WXASTORAGE_DETAIL_TOOLBAR_HEIGHT)];
        [_container addSubview:self.textLabel];
    }
    return _container;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _container.frame.size.width-20, 0)];
        _textLabel.textColor = [UIColor darkGrayColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, _panel.frame.size.height-WXASTORAGE_DETAIL_TOOLBAR_HEIGHT, _panel.frame.size.width, WXASTORAGE_DETAIL_TOOLBAR_HEIGHT)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        
        [_toolBar addSubview:self.okButton];
        [_toolBar addSubview:self.copyButton];
    }
    return _toolBar;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.layer.cornerRadius = 5;
        _okButton.layer.masksToBounds = YES;
        _okButton.frame = CGRectMake((_toolBar.frame.size.width-80*2-20)/2, 5, 80,30);
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okButton.backgroundColor = [UIColor orangeColor];
        [_okButton addTarget:self action:@selector(closeWindow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}

- (UIButton *)copyButton {
    if (!_copyButton) {
        _copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _copyButton.layer.cornerRadius = 5;
        _copyButton.layer.masksToBounds = YES;
        _copyButton.frame = CGRectMake((_toolBar.frame.size.width-80*2-20)/2+80+20, 5, 80, 30);
        [_copyButton setTitle:@"复制" forState:UIControlStateNormal];
        _copyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _copyButton.backgroundColor = [UIColor orangeColor];
        [_copyButton addTarget:self action:@selector(copyText:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyButton;
}

@end
