//
//  WXABaseContentView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/8.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXABaseContentView : UIView

@property (nonatomic, copy) void(^onContentSizeChanged)(CGRect contentRect);

@end
