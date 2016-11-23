//
//  WXALogContainer.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/27.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXABaseContainer.h"
#import "WXALogSettingsModel.h"

@protocol WXALogContainerDelegate <NSObject>

- (void)onClearLog;
- (void)onLogFilterChanged:(WXALogFilterModel *)filterModel;

@end

@interface WXALogContainer : WXABaseContainer

@property (nonatomic, weak) id<WXALogContainerDelegate> logDelegate;

- (void)refreshData:(NSArray *)data;
- (void)setLogFilter:(WXALogFilterModel *)filterModel;

@end
