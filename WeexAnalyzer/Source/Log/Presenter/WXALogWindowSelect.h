//
//  WXALogWindowSelect.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/26.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXALogSettingsModel.h"

@protocol WXALogWindowFilterDelegate <NSObject>

- (void)closeAllFloatingLayer;
- (void)onWindowSizeChanged:(WXALogWindowType)windowType;

@end

@interface WXALogWindowSelect : NSObject

@property (nonatomic, weak) id<WXALogWindowFilterDelegate> delegate;
@property (nonatomic, assign) WXALogWindowType windowType;
@property (nonatomic, strong) UIButton *filterBtn;

- (instancetype)initWithFrame:(CGRect)frame
                     hostView:(UIView *)hostView
                     hostRect:(CGRect)hostRect;

- (void)adjustHostRect:(CGRect)hostRect;
- (void)closeFloatingLayer:(BOOL)animated;

@end
