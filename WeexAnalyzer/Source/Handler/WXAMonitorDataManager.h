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
#define kWXAMonitorWXBundleUrlNotification @"kWXAMonitorWXBundleUrlNotification"

NS_ASSUME_NONNULL_BEGIN

@interface WXAMonitorDataManager : NSObject

@property(nonatomic, copy) NSString *latestInstanceId;

+ (instancetype)sharedInstance;

- (void)transfer:(NSDictionary *)value;

- (NSArray<NSDictionary *> *)allInstance;

- (NSDictionary *)latestInstance;

- (NSDictionary *)instanceDictForId:(NSString *)instaneId;

@end

NS_ASSUME_NONNULL_END
