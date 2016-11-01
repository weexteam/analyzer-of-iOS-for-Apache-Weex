//
//  WXALogSettingsModel.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogSettingsModel.h"

@implementation WXALogSettingsModel

- (instancetype)init {
    if (self = [super init]) {
        self.filter = [[WXALogFilterModel alloc] init];
        self.windowType = WXALogWindowTypeMedium;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [self init]) {
        if (dic) {
            self.filter = [[WXALogFilterModel alloc] initWithDictionary:dic[@"filter"]];
            self.windowType = WXALogWindowTypeMedium;
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSDictionary *dic = @{@"filter":[self.filter toDictionary],
                          @"windowType":@(self.windowType)};
    return dic;
}

@end
