//
//  WXAPerformanceViewController.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/4/10.
//

#import "WXABaseTableViewController.h"
#import "WXAPerformanceModel.h"

@interface WXAPerformanceData : NSObject

@property(nonatomic, copy) NSString *instanceId;
@property(nonatomic, copy) NSString *bundleUrl;
@property(nonatomic, strong) NSArray<WXAPerformanceModel *> *models;

@end

@interface WXAPerformanceViewController : WXABaseTableViewController

@property(nonatomic, strong) NSMutableArray *data;

@end
