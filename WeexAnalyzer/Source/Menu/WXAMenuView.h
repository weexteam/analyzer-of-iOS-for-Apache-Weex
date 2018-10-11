//
//  WXAMenuView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXAMenuItem.h"

#define WXAMenuItemTag 777

@interface WXAMenuView : UIView

+ (void)showMenuWithItems:(NSArray<WXAMenuItem *> *)items;

@end
