//
//  WXAMonitorHandler.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/3/13.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WXAnalyzerProtocol.h>

#define kWXAMonitorHandlerNotification @"kWXAMonitorHandlerNotification"

@interface WXAMonitorHandler : NSObject <WXAnalyzerProtocol>

@property(nonatomic, strong) NSMutableDictionary<NSString *,NSMutableDictionary*> *monitorDictionary;

+ (instancetype)sharedInstance;

@end
