//
//  WXAPerformanceCell.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/29.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXAPerformanceModel.h"

@interface WXAPerformanceCell : UITableViewCell

@property (nonatomic, strong) WXAPerformanceModel *model;

+ (CGFloat)estimateCellHeight:(WXAPerformanceModel *)model containerWidth:(CGFloat)width;

@end
