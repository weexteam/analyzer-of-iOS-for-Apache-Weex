//
//  WXALogMenuItem.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/23.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <WeexAnalyzer/WeexAnalyzer.h>
#import "WXALogProtocol.h"

@interface WXALogMenuItem : WXAMenuItem

- (instancetype)initWithTitle:(NSString *)title
                iconImageName:(NSString *)iconImageName
                       logger:(id<WXALogProtocol>)logger;

@end
