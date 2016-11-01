//
//  WXALogManager.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/20.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogManager.h"
#import "UIView+WXAPopover.h"
#import <WeexSDK/WeexSDK.h>
#import "WXAExternalLogger.h"
#import "WXAUtility.h"
#import "WXALogFilter.h"
#import "WXALogSortBar.h"
#import "WXALogResultCell.h"
#import "WXALogWindowSelect.h"
#import "WXALogResultView.h"
#import "WXALogSortBar.h"
#import "WXALogContainer.h"

#define WXALOG_SORTBAR_HEIGHT               40
#define WXALOG_SETTINGS_KEY                 @"wxalog_settings_key"

@interface WXALogManager () <WXAExternalLogDelegate, WXALogContainerDelegate, WXALogSortBarDelegate>

@property (nonatomic, strong) WXALogContainer *container;
@property (nonatomic, strong) WXALogResultView *logTableView;
@property (nonatomic, strong) WXALogSortBar *sortBar;
@property (nonatomic, strong) UIButton *tipButton;

@property (nonatomic, strong) WXAExternalLogger *logger;
@property (nonatomic, strong) WXALogSettingsModel *settings;

@property (nonatomic, strong) NSArray *sortedLogs;

@end

@implementation WXALogManager

- (instancetype)init {
    if (self = [super init]) {
        _sortedLogs = [NSArray array];
    }
    return self;
}

- (WXAMenuItem *)mItem {
    if (!_mItem) {
        _mItem = [[WXAMenuItem alloc] init];
        _mItem.title = @"JS日志";
        __weak typeof(self) welf = self;
        _mItem.handler = ^(BOOL selected) {
            if (selected) {
                [welf show];
            } else {
                [welf hide];
            }
        };
    }
    return _mItem;
}

- (void)hide {
    [self stopLogging];
}

- (void)show {
    // 注册log
    __weak typeof(self) welf = self;
    [self.container WeexAnalyzer_popover:^{
        welf.container.transform = CGAffineTransformMakeTranslation(0, welf.container.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            welf.container.transform = CGAffineTransformIdentity;
        }];
    }];
    [self startLogging];
}

- (void)free {
    [self stopLogging];
    
    [_sortBar removeFromSuperview];
    _sortBar = nil;
    [_logTableView removeFromSuperview];
    _logTableView = nil;
    [_tipButton removeFromSuperview];
    _tipButton = nil;
    _container = nil;
}

- (void)startLogging {
    [WXLog registerExternalLog:self.logger];
}

- (void)stopLogging {
    [_logger stopLog];
    _logger = nil;
    _sortedLogs = nil;
    
    [_container removeFromSuperview];
}

#pragma mark - actions
- (void)sortLogsByFilter {
    NSMutableArray *array = [NSMutableArray array];
    for (WXALogModel *model in self.logger.totalLogs) {
        if (model.flag & self.settings.filter.logFlag) {
            [array addObject:model];
        }
    }
    self.sortedLogs = [array copy];
}

- (void)changeWindowType:(WXALogWindowType)windowType {
    self.sortBar.hidden = (windowType == WXALogWindowTypeSmall);
    self.logTableView.hidden = (windowType == WXALogWindowTypeSmall);
    self.tipButton.hidden = !(windowType == WXALogWindowTypeSmall);
    
    [self.container changedWindowType:windowType];
}

- (void)expandAction:(UIButton *)sender {
    [self.sortBar.windowFilter setWindowType:WXALogWindowTypeMedium];
    [self onWindowTypeChanged:WXALogWindowTypeMedium];
}

#pragma mark - WXAExternalLogDelegate
- (void)newLogsReceived {
    [self sortLogsByFilter];
    self.logTableView.data = self.sortedLogs;
    [self.logTableView reloadResults];
}

#pragma mark - WXALogSortBarDelegate
- (void)onClearLog {
    [self.logger clearLogs];
    self.sortedLogs = [NSArray array];
    self.logTableView.data = self.sortedLogs;
    [self.logTableView reloadResults];
}

- (void)onLockLog {
    _logTableView.autoScroll = !_logTableView.autoScroll;
}

- (void)onCloseLog {
    [self hide];
}

- (void)onFilterChanged:(WXALogFilterModel *)filterModel {
    self.settings.filter = filterModel;
    [self.logger setLogLevel:filterModel.logLevel];
    
    [self sortLogsByFilter];
    self.logTableView.data = self.sortedLogs;
    [self.logTableView reloadResults];
    
    [self saveLogSettings];
}

- (void)onWindowTypeChanged:(WXALogWindowType)windowType {
    self.settings.windowType = windowType;
    [self changeWindowType:windowType];
    
    [self saveLogSettings];
}

- (void)saveLogSettings {
    NSDictionary *dic = [self.settings toDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:WXALOG_SETTINGS_KEY];
}

#pragma mark - WXALogContainerDelegate
- (void)onContainerSizeChanged {
    self.logTableView.frame = CGRectMake(0, WXALOG_SORTBAR_HEIGHT, WXA_SCREEN_WIDTH, self.container.frame.size.height-WXALOG_SORTBAR_HEIGHT);
    [self.sortBar onHostViewSizeChanged];
}

#pragma mark - Setters
- (WXALogContainer *)container {
    if (!_container) {
        _container = [[WXALogContainer alloc] initWithFrame:CGRectZero
                                                 windowType:self.settings.windowType];
        _container.delegate = self;
        [_container addSubview:self.sortBar];
        [_container addSubview:self.logTableView];
        [_container addSubview:self.tipButton];
    }
    return _container;
}

- (UITableView *)logTableView {
    if (!_logTableView) {
        _logTableView = [[WXALogResultView alloc] initWithFrame:CGRectMake(0, WXALOG_SORTBAR_HEIGHT, WXA_SCREEN_WIDTH, self.container.frame.size.height-WXALOG_SORTBAR_HEIGHT)];
    }
    return _logTableView;
}

- (UIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tipButton.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        CGRect frame = [WXALogContainer frameForWindowType:WXALogWindowTypeSmall];
        _tipButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [_tipButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _tipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_tipButton setTitle:@"WeexAnalyzer" forState:UIControlStateNormal];
        _tipButton.hidden = YES;
        [_tipButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipButton;
}

- (WXALogSortBar *)sortBar {
    if (!_sortBar) {
        _sortBar = [[WXALogSortBar alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, WXALOG_SORTBAR_HEIGHT) hostView:_container settings:self.settings];
        _sortBar.delegate = self;
    }
    return _sortBar;
}

- (WXALogSettingsModel *)settings {
    if (!_settings) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:WXALOG_SETTINGS_KEY];
        _settings = [[WXALogSettingsModel alloc] initWithDictionary:dic];
    }
    return _settings;
}

- (WXAExternalLogger *)logger {
    if (!_logger) {
        _logger = [[WXAExternalLogger alloc] init];
        _logger.delegate = self;
        [_logger setLogLevel:self.settings.filter.logLevel];
    }
    return _logger;
}

@end
