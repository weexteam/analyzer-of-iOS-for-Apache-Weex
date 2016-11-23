//
//  WXALogFilterView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXALogLevelView.h"
#import "WXALogFlagView.h"
#import "WXALogFilterModel.h"
#import "WXAOptionBaseView.h"

@interface WXALogFilterView : WXAOptionBaseView

- (instancetype)initWithFrame:(CGRect)frame
                   hostOption:(WXAOptionButton *)hostOption
                      handler:(void (^)(WXALogFilterModel *))handler;

- (void)setLogFilter:(WXALogFilterModel *)filterModel;

@end
