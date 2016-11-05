//
//  WXAStorageContainer.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXAStorageContainerDelegate <NSObject>

- (void)onCloseWindow;

@end

@interface WXAStorageContainer : UIView

@property (nonatomic, weak) id<WXAStorageContainerDelegate> delegate;

- (void)refreshData;

@end
