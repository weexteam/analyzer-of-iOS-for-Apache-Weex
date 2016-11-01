//
//  WXALogResultCell.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXALogModel.h"

@interface WXALogResultCell : UITableViewCell

@property (nonatomic, strong) WXALogModel *log;

+ (CGFloat)estimatedHeightForLog:(WXALogModel *)log;

@end
