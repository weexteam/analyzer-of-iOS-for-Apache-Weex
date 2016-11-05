//
//  WXAStorageInfoModel.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAStorageInfoModel.h"

@implementation WXAStorageInfoModel

- (instancetype)initWithKey:(NSString *)key Dic:(NSDictionary *)dic dateFormatter:(NSDateFormatter *)formatter {
    if (self = [super init]) {
        if (dic) {
            self.key = key;
            self.lastUpdateTime = [dic[@"ts"] doubleValue];
            self.persistent = (dic[@"persistent"] ? [dic[@"persistent"] boolValue] : NO);
            self.size = (dic[@"size"] ? [dic[@"size"] longLongValue] : 0);
            self.sizeStr = [self sizeToString:self.size];
            self.persistentStr = (self.persistent ? @"✔️" : @"");

            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.lastUpdateTime];
            self.timeStr = [formatter stringFromDate:date];
        }
    }
    return self;
}

- (NSString *)sizeToString:(long long)size {
    if (size < 1024) {
        return [NSString stringWithFormat:@"%lld", size];
    } else if (size < 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2fkb", size/(1024.0)];
    } else {
        return [NSString stringWithFormat:@"%.2fMB", size/(1024*1024.0)];
    }
}

@end
