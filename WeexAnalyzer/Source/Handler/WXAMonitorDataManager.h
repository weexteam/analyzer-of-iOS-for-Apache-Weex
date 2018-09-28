//
//  WXAMonitorDataManager.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/28.
//

#import <Foundation/Foundation.h>

#define kWXAMonitorNewInstanceNotification @"kWXAMonitorNewInstanceNotification"
#define kWXAMonitorSelectNotification @"kWXAMonitorSelectNotification"
#define kWXAMonitorHandlerNotification @"kWXAMonitorHandlerNotification"

NS_ASSUME_NONNULL_BEGIN

@interface WXAMonitorDataManager : NSObject

@property(nonatomic, strong) NSMutableDictionary<NSString *,NSMutableDictionary *> *monitorDictionary;
@property(nonatomic, strong) NSMutableArray<NSMutableDictionary *> *instanceArray;
@property(nonatomic, copy) NSString *latestInstanceId;

+ (instancetype)sharedInstance;

- (void)transfer:(NSDictionary *)value;

- (NSArray<NSDictionary *> *)allInstance;

- (NSDictionary *)latestInstance;

- (NSDictionary *)latestMonitorData;

@end

NS_ASSUME_NONNULL_END
