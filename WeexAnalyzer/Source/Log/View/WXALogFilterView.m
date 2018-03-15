//
//  WXALogFilterView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#define WXALOG_LOGFILTER_BOTTOM_HEIGHT  40

#import "WXALogFilterView.h"
#import "WXACellView.h"

@interface WXALogFilterView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *container;
@property (nonatomic, strong) WXALogLevelView *logLevelView;
@property (nonatomic, strong) WXALogFlagView *logFlagView;
@property (nonatomic, strong) WXACellView *logTypeView;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, copy) void(^handler)(WXALogFilterModel *filterModel);

@end

@implementation WXALogFilterView

- (instancetype)initWithFrame:(CGRect)frame
                   hostOption:(WXAOptionButton *)hostOption
                      handler:(void (^)(WXALogFilterModel *))handler {
    if (self = [super initWithFrame:frame hostOption:hostOption]) {
        _handler = handler;
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self addSubview:self.container];
        [self.container addSubview:self.logFlagView];
        [self.container addSubview:self.logLevelView];
        [self.container addSubview:self.logTypeView];
        [self addSubview:self.confirmBtn];
        [self adjustSubviews];
    }
    return self;
}

#pragma mark - public methods
- (void)setLogFilter:(WXALogFilterModel *)filterModel {
    [self.logFlagView setLogFlag:filterModel.logFlag];
    [self.logLevelView setLogLevel:filterModel.logLevel];
    [self.logTypeView setResult:@[@(filterModel.logType)]];
}

#pragma mark - actions
- (void)confirmAction:(id)sender {
    if (_handler) {
        WXALogFilterModel *filterModel = [[WXALogFilterModel alloc] init];
        filterModel.logFlag = self.logFlagView.logFlag;
        filterModel.logLevel = self.logLevelView.logLevel;
        filterModel.logType = [self.logTypeView.result[0] intValue];
        _handler(filterModel);
    }
}

- (void)adjustSubviews {
    _logLevelView.frame = CGRectMake(10, _logFlagView.frame.origin.y+_logFlagView.frame.size.height, _logLevelView.frame.size.width, _logLevelView.frame.size.height);
    _logTypeView.frame = CGRectMake(10, _logLevelView.frame.origin.y+_logLevelView.frame.size.height, _logTypeView.frame.size.width, _logTypeView.frame.size.height);
    _container.contentSize = CGSizeMake(_container.frame.size.width, _logLevelView.frame.origin.y+_logLevelView.frame.size.height+_logTypeView.frame.size.height);
}

#pragma mark - Getters
- (UIScrollView *)container {
    if (!_container) {
        _container = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-WXALOG_LOGFILTER_BOTTOM_HEIGHT)];
        _container.delegate = self;
        _container.directionalLockEnabled = YES;
        _container.bounces = YES;
        _container.layer.masksToBounds = YES;
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

- (WXALogLevelView *)logLevelView {
    if (!_logLevelView) {
        _logLevelView = [[WXALogLevelView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 0)];
        _logLevelView.backgroundColor = [UIColor whiteColor];
    }
    return _logLevelView;
}

- (WXALogFlagView *)logFlagView {
    if (!_logFlagView) {
        _logFlagView = [[WXALogFlagView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 0)];
        _logFlagView.backgroundColor = [UIColor whiteColor];
    }
    return _logFlagView;
}

- (WXACellView *)logTypeView {
    if (!_logTypeView) {
        WXACellModel *model = [WXACellModel new];
        model.title = @"日志类型";
        model.keys = @[@(WXLogTypeNative),@(WXLogTypeJS),@(WXLogTypeAll)];
        model.dictionary = @{
                             @(WXLogTypeNative) : @"Native",
                             @(WXLogTypeJS) : @"JS",
                             @(WXLogTypeAll) : @"All",
                             };
        model.isSingle = YES;
        _logTypeView = [[WXACellView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 0)
                                                    model:model];
        _logTypeView.backgroundColor = [UIColor whiteColor];
    }
    return _logTypeView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(10, self.frame.size.height - WXALOG_LOGFILTER_BOTTOM_HEIGHT, self.frame.size.width-20, WXALOG_LOGFILTER_BOTTOM_HEIGHT-5);
        _confirmBtn.backgroundColor = [UIColor orangeColor];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _confirmBtn.layer.cornerRadius = 3;
        _confirmBtn.layer.masksToBounds = YES;
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
