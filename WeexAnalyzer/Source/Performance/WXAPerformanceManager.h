//
//  WXAPerformanceManager.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/29.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@interface WXAPerformanceManager : NSObject

@property (nonatomic, strong) WXSDKInstance *wxInstance;

- (void)show;
- (void)hide;
- (void)free;

@end
