//
//  WXAViewControllerUtil.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/20.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXAViewControllerUtil : NSObject

/**
 * @brief 获得当前应用中的VC
 *
 * @return 最上层VC
 */
+ (UIViewController *)getRootViewController;

/**
 * @brief 获取当前应用中最上层的normal状态的window
 *
 * 在很多场景需要排除alertWindow等状态
 * 以便在合适的位置插入新的VC
 *
 * @return 最上层的NORMAL WINDOW VC
 */
+ (UIViewController *)getNormalRootViewController;

+ (UIWindow *)getTopWindow;

@end
