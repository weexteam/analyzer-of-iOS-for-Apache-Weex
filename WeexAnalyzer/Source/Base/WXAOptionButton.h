//
//  WXAOptionButton.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXAOptionButton : UIButton

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *selectedTitle;

- (instancetype)initWithTitle:(NSString *)title
                 clickHandler:(void(^)(UIButton *button))clickHandler;

- (instancetype)initWithTitle:(NSString *)title
                selectedTitle:(NSString *)selectedTitle
                 clickHandler:(void(^)(UIButton *button))clickHandler;

- (instancetype)initWithTitle:(NSString *)title
                  dragHandler:(void(^)(UIButton *button, CGPoint point))dragHandler;

- (instancetype)initWithTitle:(NSString *)title
                selectedTitle:(NSString *)selectedTitle
                 clickHandler:(void(^)(UIButton *button))clickHandler
                  dragHandler:(void(^)(UIButton *button, CGPoint point))dragHandler;

@end
