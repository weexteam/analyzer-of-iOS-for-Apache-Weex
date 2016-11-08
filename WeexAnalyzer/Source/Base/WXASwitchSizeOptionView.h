//
//  WXASwitchSizeOptionView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/6.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXALogSettingsModel.h"
#import "WXAOptionBaseView.h"

@interface WXASwitchSizeOptionView : WXAOptionBaseView

@property (nonatomic, assign) WXALogWindowType windowType;

- (instancetype)initWithFrame:(CGRect)frame
                   hostOption:(WXAOptionButton *)hostOption
                   windowType:(WXALogWindowType)windowType
                      handler:(void(^)(WXALogWindowType windowType))handler;

@end
