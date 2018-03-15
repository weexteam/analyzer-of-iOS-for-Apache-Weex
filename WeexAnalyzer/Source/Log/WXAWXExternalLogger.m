//
//  WXAWXExternalLogger.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/23.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAWXExternalLogger.h"
#import <WeexSDK/WeexSDK.h>
#import <pthread/pthread.h>
#import "WXALogFilterModel.h"

#define WXALOG_LOGGER_THROTTLE  500.0

@interface WXAWXExternalLogger () <WXLogProtocol>

@end

@implementation WXAWXExternalLogger {
    WXLogLevel _logLevel;
    WXLogFlag _logFlag;
    WXLogType _logType;
    NSMutableArray *_totalLogs;
    NSDateFormatter *_dateFormatter;
    
    NSTimeInterval _lastSendTime;
    NSTimer *_timer;
    
    pthread_mutex_t mutex;
}

@synthesize logManager;
@synthesize logs;

- (instancetype)init {
    if (self = [super init]) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        _totalLogs = [NSMutableArray array];
        logs = [NSArray array];
        _lastSendTime = [[NSDate date] timeIntervalSince1970] * 1000;
        _logLevel = WXLogLevelLog;
        pthread_mutex_init(&mutex, NULL);
    }
    return self;
}
    
- (void)dealloc {
    pthread_mutex_destroy(&mutex);
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
    pthread_mutex_lock(&mutex);
    _totalLogs = [NSMutableArray array];
    pthread_mutex_unlock(&mutex);
    [self sortLogs];
}

- (void)onChangeLogLevel:(NSInteger)level
                 logFlag:(NSInteger)flag
                 logType:(NSInteger)type {
    _logLevel = (WXLogLevel)level;
    _logFlag = (WXLogFlag)flag;
    _logType = (WXLogType)type;
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
    
    pthread_mutex_lock(&mutex);
    [_totalLogs addObject:model];
    pthread_mutex_unlock(&mutex);
    
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
    pthread_mutex_lock(&mutex);
    NSMutableArray *array = [NSMutableArray array];
    for (WXALogModel *model in _totalLogs) {
        if (model.flag & _logFlag) {
            
            BOOL typeRight = NO;
            if ([model.message containsString:@"jsLog:"]) {
                if (_logType==WXLogTypeJS || _logType == WXLogTypeAll) {
                    typeRight = YES;
                }
            } else {
                if (_logType==WXLogTypeNative || _logType == WXLogTypeAll) {
                    typeRight = YES;
                }
            }
            if (typeRight) {
                [array addObject:model];
            }
        }
    }
    logs = [array copy];
    pthread_mutex_unlock(&mutex);
    
    __weak typeof(self) welf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [welf.logManager onLogsChanged];
    });
}

- (void)startCheckTask {
    _timer = [NSTimer scheduledTimerWithTimeInterval:WXALOG_LOGGER_THROTTLE*2/1000 target:self selector:@selector(invokeTask) userInfo:nil repeats:NO];
}

- (void)cancelCheckTask {
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)invokeTask {
    [self sortLogs];
}

@end
