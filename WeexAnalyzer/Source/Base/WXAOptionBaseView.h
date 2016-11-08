//
//  WXAOptionBaseView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/8.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXAOptionButton.h"

@interface WXAOptionBaseView : UIView

@property (nonatomic, weak) WXAOptionButton *hostOption;

- (instancetype)initWithFrame:(CGRect)frame hostOption:(WXAOptionButton *)hostOption;

@end
