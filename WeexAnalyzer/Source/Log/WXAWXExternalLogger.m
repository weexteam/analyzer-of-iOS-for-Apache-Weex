//
//  WXAWXExternalLogger.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/23.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAWXExternalLogger.h"
#import <WeexSDK/WeexSDK.h>

#define WXALOG_LOGGER_THROTTLE  500.0

@interface WXAWXExternalLogger () <WXLogProtocol>

@end

@implementation WXAWXExternalLogger {
    WXLogLevel _logLevel;
    WXLogFlag _logFlag;
    NSArray *_totalLogs;
    NSDateFormatter *_dateFormatter;
    
    NSTimeInterval _lastSendTime;
    NSTimer *_timer;
}

@synthesize logManager;
@synthesize logs;

- (instancetype)init {
    if (self = [super init]) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        _totalLogs = [NSArray array];
        logs = [NSArray array];
        _lastSendTime = [[NSDate date] timeIntervalSince1970] * 1000;
        _logLevel = WXLogLevelLog;
    }
    return self;
}

#pragma mark - WXALogProtocol
- (void)onStartLog {
    [WXLog registerExternalLog:self];
}

- (void)onStopLog {
    [self cancelCheckTask];
    [self onClearLog];
}

- (void)onClearLog {
    _totalLogs = [NSArray array];
    [self sortLogs];
}

- (void)onChangeLogLevel:(NSInteger)level logFlag:(NSInteger)flag {
    _logLevel = (WXLogLevel)level;
    _logFlag = (WXLogFlag)flag;
    [self sortLogs];
}

#pragma mark - WXLogProtocol
- (WXLogLevel)logLevel {
    return _logLevel;
}

- (void)log:(WXLogFlag)flag message:(NSString *)message {
    [self cancelCheckTask];
    
    WXALogModel *model = [WXALogModel new];
    model.flag = flag;
    NSString *timeStr = [_dateFormatter stringFromDate:[NSDate date]];
    model.message = [NSString stringWithFormat:@"%@: %@",timeStr,message];
    
    NSMutableArray *array = [_totalLogs mutableCopy];
    [array addObject:model];
    _totalLogs = [array copy];
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970] * 1000;
    if (nowTime - _lastSendTime >= WXALOG_LOGGER_THROTTLE) {
        _lastSendTime = nowTime;
        __weak typeof(self) welf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [welf sortLogs];
        });
    } else {
        [self startCheckTask];
    }
}

#pragma mark - private methods
- (void)sortLogs {
    NSMutableArray *array = [NSMutableArray array];
    for (WXALogModel *model in _totalLogs) {
        if (model.flag & _logFlag) {
            [array addObject:model];
        }
    }
    logs = [array copy];
    
    __weak typeof(self) welf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [welf.logManager onLogsChanged];
    });
}

- (void)startCheckTask {
    _timer = [NSTimer scheduledTimerWithTimeInterval:WXALOG_LOGGER_THROTTLE*2/1000 target:self selector:@selector(invokeTask) userInfo:nil repeats:NO];
}

- (void)cancelCheckTask {
    [_timer invalidate];
    _timer = nil;
}

- (void)invokeTask {
    [self sortLogs];
}

@end
