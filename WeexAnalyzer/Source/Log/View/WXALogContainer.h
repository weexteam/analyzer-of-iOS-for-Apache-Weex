//
//  WXALogContainer.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/27.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXALogSettingsModel.h"

@protocol WXALogContainerDelegate <NSObject>

- (void)onContainerSizeChanged;

@end

@interface WXALogContainer : UIView

@property (nonatomic, weak) id<WXALogContainerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame windowType:(WXALogWindowType)windowType;

- (void)changedWindowType:(WXALogWindowType)windowType;

+ (CGRect)frameForWindowType:(WXALogWindowType)windowType;

@end
