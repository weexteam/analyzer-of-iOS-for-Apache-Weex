//
//  WXAExternalLogger.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/24.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXAExternalLogger.h"

#define WXALOG_LOGGER_THROTTLE  500.0

@implementation WXAExternalLogger {
    WXLogLevel _logLevel;
    NSDateFormatter *_dateFormatter;
    
    NSTimeInterval _lastSendTime;
    NSTimer *_timer;
}

- (instancetype)init {
    if (self = [super init]) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        _totalLogs = [NSArray array];
        _lastSendTime = [[NSDate date] timeIntervalSince1970] * 1000;
    }
    return self;
}

- (void)setLogLevel:(WXLogLevel)logLevel {
    _logLevel = logLevel;
}

- (void)clearLogs {
    self.totalLogs = [NSArray array];
}

- (void)stopLog {
    [self cancelCheckTask];
    [self clearLogs];
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
    
    NSMutableArray *array = [self.totalLogs mutableCopy];
    [array addObject:model];
    self.totalLogs = [array copy];
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970] * 1000;
    if (nowTime - _lastSendTime >= WXALOG_LOGGER_THROTTLE) {
        _lastSendTime = nowTime;
        __weak typeof(self) welf = self;
        NSLog(@"---a:msg send");
        dispatch_async(dispatch_get_main_queue(), ^{
            [welf.delegate newLogsReceived];
        });
    } else {
        [self startCheckTask];
    }
}

- (void)startCheckTask {
    NSLog(@"---a:start task");
    _timer = [NSTimer scheduledTimerWithTimeInterval:WXALOG_LOGGER_THROTTLE*2/1000 target:self selector:@selector(invokeTask) userInfo:nil repeats:NO];
}

- (void)cancelCheckTask {
    NSLog(@"---a:cancel task");
    [_timer invalidate];
    _timer = nil;
}

- (void)invokeTask {
    NSLog(@"---a:execute task");
    [self.delegate newLogsReceived];
}

@end
