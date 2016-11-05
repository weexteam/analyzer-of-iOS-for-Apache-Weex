//
//  WXAStorageDetailView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/3.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXAStorageDetailViewDelegate <NSObject>

- (void)onCloseDetailWindow;

@end

@interface WXAStorageDetailView : UIView

@property (nonatomic, copy) NSString *itemValue;

@property (nonatomic, weak) id<WXAStorageDetailViewDelegate> delegate;

- (void)showInView:(UIView *)parentView;

@end
