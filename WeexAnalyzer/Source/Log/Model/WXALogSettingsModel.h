//
//  WXALogSettingsModel.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXALogFilterModel.h"

typedef NS_ENUM(NSUInteger, WXALogWindowType) {
    WXALogWindowTypeSmall = 0,
    WXALogWindowTypeMedium,
    WXALogWindowTypeFullScreen,
};

@interface WXALogSettingsModel : NSObject

@property (nonatomic, strong) WXALogFilterModel *filter;
@property (nonatomic, assign) WXALogWindowType windowType;

- (NSDictionary *)toDictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
