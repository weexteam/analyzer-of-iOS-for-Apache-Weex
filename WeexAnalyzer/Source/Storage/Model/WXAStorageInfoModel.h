//
//  WXAStorageInfoModel.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXAStorageInfoModel : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSTimeInterval lastUpdateTime;
@property (nonatomic, assign) BOOL persistent;
@property (nonatomic, assign) long long size;

@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *sizeStr;
@property (nonatomic, copy) NSString *persistentStr;

- (instancetype)initWithKey:(NSString *)key Dic:(NSDictionary *)dic dateFormatter:(NSDateFormatter *)formatter;

@end
