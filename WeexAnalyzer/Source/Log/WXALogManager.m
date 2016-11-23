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
#import "WXALogContainer.h"

#define WXALOG_SETTINGS_KEY                 @"wxalog_settings_key"

@interface WXALogManager () <WXAExternalLogDelegate, WXALogContainerDelegate, WXABaseContainerDelegate>

@property (nonatomic, strong) WXALogContainer *container;
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

#pragma mark - WXAExternalLogDelegate
- (void)newLogsReceived {
    [self sortLogsByFilter];
    [self.container refreshData:self.sortedLogs];
}

#pragma mark - WXALogContainerDelegate
- (void)onClearLog {
    [self.logger clearLogs];
    [self sortLogsByFilter];
    [self.container refreshData:self.sortedLogs];
}

- (void)onLogFilterChanged:(WXALogFilterModel *)filterModel {
    self.settings.filter = filterModel;
    [self.logger setLogLevel:filterModel.logLevel];
    
    [self sortLogsByFilter];
    [self.container refreshData:self.sortedLogs];
    [self.container setLogFilter:filterModel];
    
    [self saveLogSettings];
}

#pragma mark - WXABaseContainerDelegate
- (void)onCloseWindow {
    [self hide];
}

- (void)saveLogSettings {
    NSDictionary *dic = [self.settings toDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:WXALOG_SETTINGS_KEY];
}

#pragma mark - Setters
- (WXALogContainer *)container {
    if (!_container) {
        _container = [[WXALogContainer alloc] initWithWindowType:WXALogWindowTypeMedium];
        [_container setLogFilter:self.settings.filter];
        _container.delegate = self;
        _container.logDelegate = self;
    }
    return _container;
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
