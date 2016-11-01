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

@protocol WXALogFilterViewDelegate <NSObject>

- (void)onLogFilterChanged:(WXLogFlag)logFlag :(WXLogLevel)logLevel;

@end

@interface WXALogFilterView : UIView

@property (nonatomic, strong) UIScrollView *container;
@property (nonatomic, strong) WXALogLevelView *logLevelView;
@property (nonatomic, strong) WXALogFlagView *logFlagView;
@property (nonatomic, weak) id<WXALogFilterViewDelegate> delegate;

- (void)setLogFilter:(WXLogFlag)logFlag :(WXLogLevel)logLevel;

@end
