//
//  WXAMonitorDataManager.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/28.
//

#import "WXAMonitorDataManager.h"
#import <WeexSDK/WXUtility.h>
#import "NSDictionary+forPath.h"
#import <pthread/pthread.h>

@interface WXAMonitorDataManager ()

@property(nonatomic, strong) NSMutableDictionary<NSString *,NSMutableDictionary *> *monitorDictionary;

@end

@implementation WXAMonitorDataManager {
    pthread_mutex_t mutex;
    pthread_mutexattr_t mutexAttr;
}

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
        pthread_mutexattr_init(&mutexAttr);
        pthread_mutexattr_settype(&mutexAttr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&mutex, &mutexAttr);
        _monitorDictionary = [NSMutableDictionary new];
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&mutex);
    pthread_mutexattr_destroy(&mutexAttr);
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
    
    [NSNotificationCenter.defaultCenter postNotificationName:kWXAMonitorHandlerNotification
                                                      object:@{
                                                               @"instanceId" : instanceId,
                                                               @"type" : type,
                                                               }];
    NSString *wxBundleUrl = [data objectForKey:@"wxBundleUrl"];
    if (wxBundleUrl) {
        [NSNotificationCenter.defaultCenter postNotificationName:kWXAMonitorWXBundleUrlNotification
                                                          object:@{
                                                                   @"instanceId" : instanceId,
                                                                   @"wxBundleUrl" : wxBundleUrl,
                                                                   }];
    }
    
    pthread_mutex_lock(&mutex);
    NSMutableDictionary *dataForInstance = _monitorDictionary[instanceId];
    if (!dataForInstance) {
        dataForInstance = [NSMutableDictionary new];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
        NSDate *currentDate = [NSDate date];
        NSString *currentDateString = [formatter stringFromDate:currentDate];
        
        [dataForInstance setObject:currentDateString forKey:@"dateline"];
        [_monitorDictionary setObject:dataForInstance forKey:instanceId];
        _latestInstanceId = instanceId;
        [NSNotificationCenter.defaultCenter postNotificationName:kWXAMonitorNewInstanceNotification object:instanceId];
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
    pthread_mutex_unlock(&mutex);
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

- (NSArray<NSDictionary *> *)allInstance {
    pthread_mutex_lock(&mutex);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_monitorDictionary.count];
    for (NSString *item in _monitorDictionary.allKeys) {
        NSString *wxBundleUrl = [_monitorDictionary[item] objectForPath:@"properties.wxBundleUrl"];
        NSString *dateline = [_monitorDictionary[item] objectForPath:@"dateline"];
        [array addObject:@{
                           @"instanceId" : item,
                           @"wxBundleUrl" : wxBundleUrl ?: @"",
                           @"dateline" : dateline ?: @"",
                           }];
    }
    [array sortUsingComparator:^NSComparisonResult(NSDictionary *  _Nonnull obj1, NSDictionary *  _Nonnull obj2) {
        return [[obj2 objectForKey:@"instanceId"] compare:[obj1 objectForKey:@"instanceId"]];
    }];
    pthread_mutex_unlock(&mutex);
    return [array copy];
}

- (NSDictionary *)latestInstance {
    return self.allInstance.lastObject;
}

- (NSDictionary *)instanceDictForId:(NSString *)instaneId {
    NSDictionary *instance = nil;
    pthread_mutex_lock(&mutex);
    instance = [_monitorDictionary objectForKey:instaneId];
    pthread_mutex_unlock(&mutex);
    return instance;
}

@end
