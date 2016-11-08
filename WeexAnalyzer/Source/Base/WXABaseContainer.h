//
//  WXABaseContainer.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXABaseOptionBar.h"
#import "WXABaseContentView.h"
#import "WXAOptionBaseView.h"

@protocol WXABaseContainerDelegate <NSObject>

- (void)onCloseWindow;

@end

@interface WXABaseContainer : UIView

@property (nonatomic, strong) WXABaseOptionBar *optionBar;
@property (nonatomic, strong) WXABaseContentView *contentView;
@property (nonatomic, weak) id<WXABaseContainerDelegate> delegate;

- (void)show;
- (void)hide;

- (void)showOptionView:(WXAOptionBaseView *)optionView;
- (void)closeOptionView:(BOOL)animated;

@end
