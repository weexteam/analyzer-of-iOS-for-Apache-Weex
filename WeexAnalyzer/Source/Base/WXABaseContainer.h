//
//  WXABaseContainer.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXABaseOptionBar.h"
#import "WXAOptionBaseView.h"
#import "WXABaseContentView.h"
#import "WXALogSettingsModel.h"

@protocol WXABaseContainerDelegate <NSObject>

- (void)onCloseWindow;

@end

@interface WXABaseContainer : UIView

@property (nonatomic, strong) WXABaseOptionBar *optionBar;
@property (nonatomic, strong) WXABaseContentView *contentView;
@property (nonatomic, weak) id<WXABaseContainerDelegate> delegate;

- (instancetype)initWithWindowType:(WXALogWindowType)windowType;

- (void)show;
- (void)hide;

- (void)showOptionView:(WXAOptionBaseView *)optionView;
- (void)closeOptionView:(BOOL)animated;

+ (CGRect)frameForWindowType:(WXALogWindowType)windowType;

@end
