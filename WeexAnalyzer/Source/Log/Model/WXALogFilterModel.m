//
//  WXALogFilterModel.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/27.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogFilterModel.h"

@implementation WXALogFilterModel

- (instancetype)init {
    if (self = [super init]) {
        self.logLevel = WXLogLevelLog;
        self.logFlag = WXLogFlagError | WXLogFlagWarning | WXLogFlagInfo | WXLogFlagLog;
        self.logType = WXLogTypeAll;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [self init]) {
        if (dic) {
            self.logLevel = [dic[@"logLevel"] integerValue];
            self.logFlag = [dic[@"logFlag"] integerValue];
            self.logType = [dic[@"logType"] integerValue];
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSDictionary *dic = @{@"logLevel":@(self.logLevel),
                          @"logFlag":@(self.logFlag),
                          @"logType":@(self.logType),
                          
                          };
    return dic;
}

@end
