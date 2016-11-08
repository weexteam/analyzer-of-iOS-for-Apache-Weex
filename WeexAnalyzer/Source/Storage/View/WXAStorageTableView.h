//
//  WXAStorageTableView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXAStorageInfoModel.h"
#import "WXABaseContainer.h"

@protocol WXAStorageTableViewDelegate <NSObject>

- (void)onShowItemDetail:(WXAStorageInfoModel *)model;
- (void)onRemoveItem:(WXAStorageInfoModel *)model;

@end

@interface WXAStorageTableView : UITableView <WXABaseContainerDelegate>

@property (nonatomic, strong) NSArray<WXAStorageInfoModel *> *data;
@property (nonatomic, weak) id<WXAStorageTableViewDelegate> bizDelegate;

@end
