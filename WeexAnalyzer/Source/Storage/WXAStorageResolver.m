//
//  WXAStorageResolver.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAStorageResolver.h"
#import <WeexSDK/WeexSDK.h>

@interface WXAStorageResolver ()

@property (nonatomic, strong) Class StorageModuleClass;
@property (nonatomic, strong) id storageInstance;

@end

@implementation WXAStorageResolver

- (NSArray<WXAStorageInfoModel *> *)getStorageInfoList {
    // get setItem method
    SEL infoSel = NSSelectorFromString(@"info");
    if (![self.storageInstance respondsToSelector:infoSel]) {
        return nil;
    }
    
    // setItem
    typedef NSDictionary<NSString *, NSDictionary *> * (*send_type)(id, SEL);
    send_type methodInstance = (send_type)[self.StorageModuleClass instanceMethodForSelector:infoSel];
    NSDictionary<NSString *, NSDictionary *> *info = [methodInstance(self.storageInstance, infoSel) copy];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd\nHH:mm:ss.SSS"];
    
    NSMutableArray<WXAStorageInfoModel *> *array = [NSMutableArray array];
    for (NSString *key in info) {
        NSDictionary *dic = info[key];
        WXAStorageInfoModel *model = [[WXAStorageInfoModel alloc] initWithKey:key Dic:dic dateFormatter:formatter];
        if (dic && model) {
            [array addObject:model];
        }
    }
    return [array copy];
}

- (void)setItem:(NSString *)key value:(NSString *)value callback:(void(^)(BOOL success))callback {
    // get setItem method
    SEL setItemSel = NSSelectorFromString(@"setItem:value:callback:");
    if (![self.storageInstance respondsToSelector:setItemSel]) {
        if (callback) {
            callback(NO);
        }
    }
    
    WXModuleCallback wxCallback = ^(NSDictionary *result) {
        if (callback) {
            BOOL success = [@"success" isEqualToString:result[@"result"]];
            callback(success);
        }
    };
    
    // setItem
    typedef void (*send_type)(id, SEL, NSString*, NSString*, WXModuleCallback);
    send_type methodInstance = (send_type)[self.StorageModuleClass instanceMethodForSelector:setItemSel];
    methodInstance(self.storageInstance, setItemSel, key, value, wxCallback);
}

- (void)getItem:(NSString *)key callback:(void(^)(BOOL success, NSString * result))callback {
    // get getItem method
    SEL getItemSel = NSSelectorFromString(@"getItem:callback:");
    if (![self.storageInstance respondsToSelector:getItemSel]) {
        if (callback) {
            callback(NO, nil);
        }
    }
    
    WXModuleCallback wxCallback = ^(NSDictionary *result) {
        if (callback) {
            BOOL success = [@"success" isEqualToString:result[@"result"]];
            NSString *value = result[@"data"];
            callback(success, value);
        }
    };
    
    // setItem
    typedef void (*send_type)(id, SEL, NSString*, WXModuleCallback);
    send_type methodInstance = (send_type)[self.StorageModuleClass instanceMethodForSelector:getItemSel];
    methodInstance(self.storageInstance, getItemSel, key, wxCallback);
}

- (void)removeItem:(NSString *)key callback:(void(^)(BOOL success))callback {
    // get removeItem method
    SEL removeItemSel = NSSelectorFromString(@"removeItem:callback:");
    if (![self.storageInstance respondsToSelector:removeItemSel]) {
        if (callback) {
            callback(NO);
        }
    }
    
    WXModuleCallback wxCallback = ^(NSDictionary *result) {
        if (callback) {
            BOOL success = [@"success" isEqualToString:result[@"result"]];
            callback(success);
        }
    };
    
    // removeItem
    typedef void (*send_type)(id, SEL, NSString*, WXModuleCallback);
    send_type methodInstance = (send_type)[self.StorageModuleClass instanceMethodForSelector:removeItemSel];
    methodInstance(self.storageInstance, removeItemSel, key, wxCallback);    
}

#pragma mark - Setters
- (Class)StorageModuleClass {
    if (!_StorageModuleClass) {
        _StorageModuleClass = NSClassFromString(@"WXStorageModule");
    }
    return _StorageModuleClass;
}

- (id)storageInstance {
    if (!_storageInstance) {
        Class StorageModuleClass = self.StorageModuleClass;
        
        // get weex-storage instance
        _storageInstance = [[StorageModuleClass alloc] init];
        if (!_storageInstance || ![_storageInstance isKindOfClass:StorageModuleClass]) {
            return nil;
        }
    }
    return _storageInstance;
}


@end
