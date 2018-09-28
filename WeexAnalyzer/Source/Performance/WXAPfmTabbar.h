//
//  WXAPfmTabbar.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXAPfmTabbar : UIView

@property (nonatomic, copy) void (^select)(NSInteger, NSInteger);

- (void)setCurrent:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
