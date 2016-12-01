//
//  WXAPerformanceModel.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/29.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAPerformanceModel.h"

@implementation WXAPerformanceModel

- (instancetype)initWithTitle:(NSString *)title
                        value:(NSString *)value
                     category:(WXAPerformanceCategory)category {
    if (self = [super init]) {
        _title = title;
        _value = value;
        _category = category;
    }
    return self;
}

+ (NSString *)categoryToStr:(WXAPerformanceCategory)category {
    switch (category) {
        case WXAPerformanceCategoryBasic:
            return @"Basic Info";
        case WXAPerformanceCategoryPerformance:
            return @"Page Performance";
        case WXAPerformanceCategoryGlobal:
            return @"SDK Performance";
        default:
            return @"";
    }
}

@end
