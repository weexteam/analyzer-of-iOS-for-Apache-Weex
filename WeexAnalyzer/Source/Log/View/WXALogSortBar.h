//
//  WXALogSortBar.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/24.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXALogFilter.h"
#import "WXALogWindowSelect.h"
#import "WXALogSettingsModel.h"

@protocol WXALogSortBarDelegate <NSObject>

- (void)onClearLog;
- (void)onLockLog;
- (void)onCloseLog;
- (void)onFilterChanged:(WXALogFilterModel *)filterModel;
- (void)onWindowTypeChanged:(WXALogWindowType)windowType;

@end

@interface WXALogSortBar : UIView

@property (nonatomic, weak) UIView *hostView;

@property (nonatomic, strong) WXALogFilter *logFilter;
@property (nonatomic, strong) WXALogWindowSelect *windowFilter;
@property (nonatomic, weak) id<WXALogSortBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame hostView:(UIView *)hostView settings:(WXALogSettingsModel *)settings;

- (void)onHostViewSizeChanged;

@end
