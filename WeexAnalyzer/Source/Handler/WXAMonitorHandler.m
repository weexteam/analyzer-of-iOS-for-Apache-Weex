//
//  WXAMonitorHandler.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/3/13.
//

#import "WXAMonitorHandler.h"
#import <WeexSDK/WXUtility.h>
#import "NSDictionary+forPath.h"

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
        _monitorDictionary = [NSMutableDictionary new];
    }
    return self;
}

- (void)transfer:(NSDictionary *)value {
    if (![value isKindOfClass:NSDictionary.class]) {
        return;
    }
    NSString *group = value[@"group"];
    if (![group isKindOfClass:NSString.class]) {
        return;
    }
    if (![group isEqualToString:@"wxapm"]) {
        return;
    }
    
    NSString *instanceId = value[@"module"];
    if (![instanceId isKindOfClass:NSString.class]) {
        return;
    }
    
    NSString *type = value[@"type"];
    if (![type isKindOfClass:NSString.class]) {
        return;
    }
    
    NSDictionary *data = value[@"data"];
    if (![data isKindOfClass:NSDictionary.class]) {
        return;
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:kWXAMonitorHandlerNotification object:type];
    
    NSMutableDictionary *dataForInstance = _monitorDictionary[instanceId];
    if (!dataForInstance) {
        dataForInstance = [NSMutableDictionary new];
        [_monitorDictionary setObject:dataForInstance forKey:instanceId];
    }
    
    if ([type isEqualToString:@"wxinteraction"]) {
        NSDictionary *newData = data;
        NSMutableArray *dataForType = [dataForInstance objectForKey:type];
        if (!dataForType) {
            dataForType = [NSMutableArray new];
            [dataForInstance setObject:dataForType forKey:type];
        } else {
            NSDictionary *lastData = [dataForType objectAtIndex:dataForType.count-1];
            newData = [self handleRenderDiffTime:data lastData:lastData];
        }
        [dataForType addObject:newData];
    } else {
        NSMutableDictionary *dataForType = [dataForInstance objectForKey:type];
        if (!dataForType) {
            dataForType = [NSMutableDictionary new];
            [dataForInstance setObject:dataForType forKey:type];
        }
        [dataForType addEntriesFromDictionary:data];
    }
}

- (NSDictionary *)handleRenderDiffTime:(NSDictionary *)data lastData:(NSDictionary *)lastData {
    NSMutableDictionary *newData = [data mutableCopy];
    if ([data isKindOfClass:NSDictionary.class]) {
        if ([lastData isKindOfClass:NSDictionary.class]) {
            NSNumber *renderOriginDiffTime = [data objectForKey:@"renderOriginDiffTime"];
            NSNumber *lastRenderOriginDiffTime = [lastData objectForKey:@"renderOriginDiffTime"];
            if ([renderOriginDiffTime isKindOfClass:NSNumber.class] && [lastRenderOriginDiffTime isKindOfClass:NSNumber.class]) {
                [newData setObject:@(renderOriginDiffTime.doubleValue - lastRenderOriginDiffTime.doubleValue) forKey:@"renderDiffTime"];
            }
            NSDictionary *style = [data objectForKey:@"style"];
            if ([style isKindOfClass:NSDictionary.class]) {
                [newData setObject:[style toString] forKey:@"styleString"];
            }
            NSDictionary *attrs = [data objectForKey:@"attrs"];
            if ([attrs isKindOfClass:NSDictionary.class]) {
                [newData setObject:[attrs toString] forKey:@"attrsString"];
            }
        }
    }
    return [newData copy];
}

@end
