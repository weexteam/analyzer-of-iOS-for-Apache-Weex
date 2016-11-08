//
//  WXAStorageResolver.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXAStorageInfoModel.h"

@interface WXAStorageResolver : NSObject

- (NSArray<WXAStorageInfoModel *> *)getStorageInfoList;

- (void)getItem:(NSString *)key callback:(void(^)(BOOL success, NSString * result))callback;

- (void)setItem:(NSString *)key value:(NSString *)value persistent:(BOOL)persistent callback:(void(^)(BOOL success))callback;

- (void)removeItem:(NSString *)key callback:(void(^)(BOOL success))callback;

@end
