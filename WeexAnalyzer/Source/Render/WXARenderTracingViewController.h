//
//  WXRenderTracingViewController.h
//  TBWXDevTool
//
//  Created by 齐山 on 2017/7/4.
//  Copyright © 2017年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WeexSDK/WXTracingManager.h>
#import "WXABaseTableViewController.h"

@interface WXAShowTracingTask : WXTracingTask
@property (nonatomic) NSTimeInterval begin;
@property (nonatomic) NSTimeInterval end;
@end

@interface WXAShowTracing : WXTracing
@property (nonatomic,strong)NSMutableArray *subTracings;
@end

@interface WXARenderTracingViewController : WXABaseTableViewController

- (instancetype)initWithFrame:(CGRect )frame;
-(void)refreshData;
@end
