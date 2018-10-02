//
//  WXAPageTabbar.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXAPageTabbar : UIView

@property (nonatomic, copy) void (^select)(NSInteger, NSInteger);

- (instancetype)initWithFrame:(CGRect)frame tabs:(NSArray<NSString*>*)tabs;
- (void)setCurrent:(NSUInteger)index;
- (NSUInteger)getCurrent;
- (void)hideTopLine;

@end

NS_ASSUME_NONNULL_END
