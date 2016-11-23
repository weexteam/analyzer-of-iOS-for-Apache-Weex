//
//  WXALogContainer.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/27.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogContainer.h"
#import "WXALogResultView.h"
#import "WXALogFilterView.h"
#import "WXAUtility.h"

#define WXALOG_OPTIONS_VIEW_HEIGHT 250

@interface WXALogContainer ()

@property (nonatomic, strong) WXALogResultView *logTableView;
@property (nonatomic, strong) WXALogFilterModel *filterModel;

@end

@implementation WXALogContainer

- (instancetype)initWithWindowType:(WXALogWindowType)windowType {
    if (self = [super initWithWindowType:windowType]) {
        [self initOptions];
        [self.contentView addSubview:self.logTableView];
        
        __weak typeof(self) welf = self;
        self.contentView.onContentSizeChanged = ^(CGRect frame) {
            welf.logTableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        };
    }
    return self;
}

- (void)initOptions {
    __weak typeof(self) welf = self;
    
    [self.optionBar addOption:[[WXAOptionButton alloc] initWithTitle:@"筛选 ↓"
                                                       selectedTitle:@"筛选 ↑"
                                                        clickHandler:^(UIButton *button) {
                                                            [welf showLogFilter:button];
                                                        }]];
    
    [self.optionBar addOption:[[WXAOptionButton alloc] initWithTitle:@"清除"
                                                        clickHandler:^(UIButton *button) {
                                                            [welf clearLog];
                                                        }]];
    
    [self.optionBar addDefaultOption:WXADefaultOptionTypeDrag];

    
    
    [self.optionBar addOption:[[WXAOptionButton alloc] initWithTitle:@"锁定"
                                                       selectedTitle:@"解锁"
                                                        clickHandler:^(UIButton *button) {
                                                            [welf lockLog:button];
                                                        }]];
    
    [self.optionBar addDefaultOption:WXADefaultOptionTypeSwitchSize];
    [self.optionBar addDefaultOption:WXADefaultOptionTypeCloseWindow];
}

#pragma mark - public methods
- (void)refreshData:(NSArray *)data {
    self.logTableView.data = data;
    [self.logTableView reloadResults];
}

- (void)setLogFilter:(WXALogFilterModel *)filterModel {
    _filterModel = filterModel;
}

#pragma mark - actions
- (void)showLogFilter:(UIButton *)sender {
    if (sender.selected) {
        [self closeOptionView:YES];
        return;
    }
    
    CGRect frame = self.contentView.frame;
    __weak typeof(self) welf = self;
    WXALogFilterView *optionView =
        [[WXALogFilterView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, WXALOG_OPTIONS_VIEW_HEIGHT)
                                     hostOption:(WXAOptionButton *)sender
                                        handler:^(WXALogFilterModel *filterModel) {
                                            [welf closeOptionView:YES];
                                            [welf onSetLogFilter:filterModel];
                                        }];
    [optionView setLogFilter:_filterModel];
    [self showOptionView:optionView];
}

- (void)onSetLogFilter:(WXALogFilterModel *)filterModel {
    [self.logDelegate onLogFilterChanged:filterModel];
}

- (void)clearLog {
    [self.logDelegate onClearLog];
}

- (void)lockLog:(UIButton *)sender {
    sender.selected = !sender.selected;
    _logTableView.autoScroll = !_logTableView.autoScroll;
}

#pragma mark - Getters
- (WXALogResultView *)logTableView {
    if (!_logTableView) {
        _logTableView = [[WXALogResultView alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, self.contentView.frame.size.height)];
    }
    return _logTableView;
}

@end
