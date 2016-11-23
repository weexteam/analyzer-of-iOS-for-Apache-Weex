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
#import "WXAUtility.h"
#import "WXALogContainer.h"

#define WXALOG_SETTINGS_KEY                 @"wxalog_settings_key"

@interface WXALogManager () <WXALogContainerDelegate, WXABaseContainerDelegate, WXALoggerDelegate>

@property (nonatomic, strong) WXALogContainer *container;
@property (nonatomic, strong) id <WXALogProtocol> logger;
@property (nonatomic, strong) WXALogSettingsModel *settings;

@property (nonatomic, strong) NSArray *sortedLogs;

@end

@implementation WXALogManager

#pragma mark - public methods
- (void)registerLogger:(id<WXALogProtocol>)logger {
    _logger = logger;
    _logger.logManager = self;
    [_logger onChangeLogLevel:self.settings.filter.logLevel logFlag:self.settings.filter.logFlag];
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
    [self hide];
    _container = nil;
}

#pragma mark - private methods
- (void)startLogging {
    [_logger onStartLog];
}

- (void)stopLogging {
    [_logger onStopLog];
    [_container removeFromSuperview];
}

- (void)saveLogSettings {
    NSDictionary *dic = [self.settings toDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:WXALOG_SETTINGS_KEY];
}

#pragma mark - WXALoggerDelegate
- (void)onLogsChanged {
    [self.container refreshData:_logger.logs];
}

#pragma mark - WXALogContainerDelegate
- (void)onClearLog {
    [self.logger onClearLog];
}

- (void)onLogFilterChanged:(WXALogFilterModel *)filterModel {
    self.settings.filter = filterModel;
    [self saveLogSettings];
    
    [self.logger onChangeLogLevel:filterModel.logLevel logFlag:filterModel.logFlag];
    [self.container setLogFilter:filterModel];
}

#pragma mark - WXABaseContainerDelegate
- (void)onCloseWindow {
    [self hide];
}

#pragma mark - Getters
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

@end
