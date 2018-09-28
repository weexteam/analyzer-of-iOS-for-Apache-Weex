//
//  WXAMonitorHandler.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/3/13.
//

#import "WXAMonitorHandler.h"
#import "WXAMonitorDataManager.h"


@implementation WXAMonitorHandler

- (void)transfer:(NSDictionary *)value {
    [[WXAMonitorDataManager sharedInstance] transfer:value];
}

@end
