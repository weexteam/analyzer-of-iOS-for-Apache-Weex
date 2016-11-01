//
//  WXAMenuItem.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXAMenuItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *selectedTitle;
@property (nonatomic, copy) void(^handler)(BOOL selected);

@end
