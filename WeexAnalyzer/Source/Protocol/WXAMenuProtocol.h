//
//  WXAHeaderProtocol.h
//  WeexAnalyzer
//
//  Created by 对象 on 2017/10/20.
//  Copyright © 2017年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@protocol WXAMenuProtocol<NSObject>

@property(nonatomic,strong,readonly) UIView *headerView;
@property(nonatomic,assign,readonly) CGRect frame;
@property(nonatomic,assign,readonly) CGFloat headerHeight;

@optional
- (void)setWxInstance:(WXSDKInstance *)wxInstance;

@end
