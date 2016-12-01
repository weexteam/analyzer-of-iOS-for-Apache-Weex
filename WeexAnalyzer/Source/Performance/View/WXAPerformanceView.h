//
//  WXAPerformanceView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXAPerformanceModel.h"

@interface WXAPerformanceView : UIView

@property (nonatomic, strong) NSArray<NSArray<WXAPerformanceModel *> *> *data;

- (void)show;
- (void)hide;

@end
