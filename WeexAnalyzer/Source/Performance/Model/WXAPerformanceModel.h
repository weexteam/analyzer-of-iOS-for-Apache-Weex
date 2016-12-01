//
//  WXAPerformanceModel.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/29.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WXAPerformanceCategory) {
    WXAPerformanceCategoryBasic = 0,
    WXAPerformanceCategoryPerformance,
    WXAPerformanceCategoryGlobal,
};

@interface WXAPerformanceModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) WXAPerformanceCategory category;

- (instancetype)initWithTitle:(NSString *)title
                        value:(NSString *)value
                     category:(WXAPerformanceCategory)category;

+ (NSString *)categoryToStr:(WXAPerformanceCategory)category;

@end
