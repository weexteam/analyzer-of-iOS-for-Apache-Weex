//
//  WXALogFilter.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/24.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>
#import "WXALogSettingsModel.h"

@protocol WXALogLevelFilterDelegate <NSObject>

- (void)closeAllFloatingLayer;
- (void)onLogFilterChanged:(WXLogFlag)logFlag :(WXLogLevel)logLevel;

@end

@interface WXALogFilter : NSObject

@property (nonatomic, weak) id <WXALogLevelFilterDelegate> delegate;
@property (nonatomic, assign) WXLogLevel logLevel;
@property (nonatomic, assign) WXLogFlag logFlag;
@property (nonatomic, strong) UIButton *filterBtn;

- (instancetype)initWithFrame:(CGRect)frame
                     hostView:(UIView *)hostView
                     hostRect:(CGRect)hostRect;

- (void)adjustHostRect:(CGRect)hostRect;
- (void)closeFloatingLayer:(BOOL)animated;

@end
