//
//  WXALogFilterModel.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/27.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@interface WXALogFilterModel : NSObject

@property (nonatomic, assign) WXLogLevel logLevel;
@property (nonatomic, assign) WXLogFlag logFlag;

- (NSDictionary *)toDictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
