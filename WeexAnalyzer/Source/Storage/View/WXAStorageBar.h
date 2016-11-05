//
//  WXAStorageBar.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXAStorageBarDelegate <NSObject>

- (void)refreshAll;
- (void)clearAll;
- (void)onCloseWindow;

@end

@interface WXAStorageBar : UIView

@property (nonatomic, weak) UIView *hostView;

@property (nonatomic, weak) id<WXAStorageBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame hostView:(UIView *)hostView;

@end
