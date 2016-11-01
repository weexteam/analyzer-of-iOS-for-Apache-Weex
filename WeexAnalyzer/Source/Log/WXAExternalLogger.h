//
//  WXAExternalLogger.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/24.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WXLog.h>
#import "WXALogModel.h"

@protocol WXAExternalLogDelegate <NSObject>

- (void)newLogsReceived;

@end

@interface WXAExternalLogger : NSObject <WXLogProtocol>

@property (nonatomic, strong) NSArray *totalLogs;
@property (nonatomic, weak) id <WXAExternalLogDelegate> delegate;

- (void)setLogLevel:(WXLogLevel)logLevel;
- (void)clearLogs;
- (void)stopLog;

@end
