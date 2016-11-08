//
//  WXAStorageInsertView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXAStorageItemModel.h"
#import "WXAOptionBaseView.h"

@interface WXAStorageInsertView : WXAOptionBaseView

- (instancetype)initWithFrame:(CGRect)frame
                   hostOption:(WXAOptionButton *)hostOption
                      handler:(void(^)(WXAStorageItemModel *item))handler;

@end
