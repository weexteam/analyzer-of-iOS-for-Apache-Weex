//
//  WXALogFilterModel.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/27.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

typedef NS_ENUM(NSUInteger, WXLogType){
    /**
     *  native log
     */
    WXLogTypeNative       = 0,
    
    /**
     *  js log
     */
    WXLogTypeJS,
    
    /**
     *  All
     */
    WXLogTypeAll
};

@interface WXALogFilterModel : NSObject

@property (nonatomic, assign) WXLogLevel logLevel;
@property (nonatomic, assign) WXLogFlag logFlag;
@property (nonatomic, assign) WXLogType logType;

- (NSDictionary *)toDictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
