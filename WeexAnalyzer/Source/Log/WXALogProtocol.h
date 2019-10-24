//
//  WXALogProtocol.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/23.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexAnalyzer/WXALogModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WXALoggerDelegate <NSObject>

- (void)onLogsChanged;

@end

@protocol WXALogProtocol <NSObject>

@property (nonatomic, weak) id<WXALoggerDelegate> logManager;
@property (nonatomic, strong) NSArray<WXALogModel *> *logs;

- (void)onStartLog;
- (void)onStopLog;
- (void)onClearLog;
- (void)onChangeLogLevel:(NSInteger)level
                 logFlag:(NSInteger)flag
                 logType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
