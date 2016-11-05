//
//  WXAStorageManager.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXAMenuItem.h"

@interface WXAStorageManager : NSObject

@property (nonatomic, strong) WXAMenuItem *mItem;

- (void)free;

@end
