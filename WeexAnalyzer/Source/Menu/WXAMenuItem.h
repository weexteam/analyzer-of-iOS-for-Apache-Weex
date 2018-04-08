//
//  WXAMenuItem.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@interface WXAMenuItem : NSObject

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *selectedTitle;
@property (nonatomic, copy) UIImage *iconImage;

@property (nonatomic, copy) void(^handler)(BOOL selected);

@property (nonatomic, strong) WXSDKInstance *wxInstance;

- (void)show: (UIViewController *)controller;

@end
