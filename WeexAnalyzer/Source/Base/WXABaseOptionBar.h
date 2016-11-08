//
//  WXABaseOptionBar.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXAOptionButton.h"

typedef NS_ENUM(NSUInteger, WXADefaultOptionType) {
    WXADefaultOptionTypeCloseWindow = 0,
    WXADefaultOptionTypeSwitchSize,
    WXADefaultOptionTypeDrag
};

@protocol WXABaseOptionBarDelegate <NSObject>

- (void)onCloseContainer;
- (void)onShowSwitchSize:(UIButton *)sender;
- (void)onChangePosition:(CGPoint)point;

@end

@interface WXABaseOptionBar : UIView

@property (nonatomic, assign) BOOL autoAdjustOptionWidth;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, weak) id<WXABaseOptionBarDelegate> delegate;

- (void)addOption:(WXAOptionButton *)option;
- (void)addDefaultOption:(WXADefaultOptionType)optionType;
- (void)clearOptionSelected;

@end
