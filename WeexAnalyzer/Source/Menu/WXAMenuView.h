//
//  WXAMenuView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXAMenuItem.h"

@interface WXAMenuView : UIView

- (instancetype)initWithItems:(NSArray<WXAMenuItem *> *)items;
- (void)showMenu;

@end
