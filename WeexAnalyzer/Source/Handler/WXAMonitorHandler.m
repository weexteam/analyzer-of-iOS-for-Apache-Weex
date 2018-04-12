//
//  WXAMonitorHandler.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/3/13.
//

#import "WXAMonitorHandler.h"
#import <WeexSDK/WXUtility.h>

@implementation WXAMonitorHandler

+ (instancetype)sharedInstance {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _monitorDictionary = [WXThreadSafeMutableDictionary new];
    }
    return self;
}

- (void)transfer:(NSDictionary *)value {
    [NSNotificationCenter.defaultCenter postNotificationName:kWXAMonitorHandlerNotification object:nil];
    if (![value isKindOfClass:NSDictionary.class]) {
        return;
    }
    NSString* instanceId = value[@"instanceId"];
    NSString *module = value[@"module"];
    if (instanceId && [instanceId isKindOfClass:NSString.class]) {
        NSMutableDictionary *dictionary = _monitorDictionary[instanceId];
        if (!dictionary) {
            dictionary = [NSMutableDictionary new];
            [_monitorDictionary setObject:dictionary forKey:instanceId];
        }
        [dictionary addEntriesFromDictionary:value];
    }
    if (module) {
        if ([module isEqualToString:MODULE_PERFORMANCE]) {

        } else if ([module isEqualToString:MODULE_ERROR]) {

        }
    }
}

@end
