//
//  WXAStorageItemModel.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXAStorageItemModel : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) BOOL persistent;

@end
