//
//  WXAOptionButton.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAOptionButton.h"

@interface WXAOptionButton ()

@property (nonatomic, copy) void(^clickHandler)(UIButton *button);
@property (nonatomic, copy) void(^dragHandler)(UIButton *button, CGPoint point);

@end

@implementation WXAOptionButton

- (instancetype)initWithTitle:(NSString *)title
                 clickHandler:(void(^)(UIButton *button))clickHandler {
    return [self initWithTitle:title selectedTitle:title clickHandler:clickHandler dragHandler:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                  dragHandler:(void(^)(UIButton *button, CGPoint point))dragHandler {
    return [self initWithTitle:title selectedTitle:title clickHandler:nil dragHandler:dragHandler];
}

- (instancetype)initWithTitle:(NSString *)title
                selectedTitle:(NSString *)selectedTitle
                 clickHandler:(void(^)(UIButton *button))clickHandler {
    return [self initWithTitle:title selectedTitle:selectedTitle clickHandler:clickHandler dragHandler:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                selectedTitle:(NSString *)selectedTitle
                 clickHandler:(void (^)(UIButton *))clickHandler
                  dragHandler:(void (^)(UIButton *, CGPoint point))dragHandler {
    if (self = [super init]) {
        _title = title;
        _selectedTitle = selectedTitle;
        _clickHandler = clickHandler;
        _dragHandler = dragHandler;
        
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:selectedTitle forState:UIControlStateSelected];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        if (clickHandler) {
            [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (dragHandler) {
            [self addTarget:self action:@selector(dragLog:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        }
    }
    return self;
}

#pragma mark - actions
- (void)clickAction:(UIButton *)sender {
    if (_clickHandler) {
        _clickHandler(sender);
    }
}

- (void)dragLog:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:sender] anyObject];
    
    // get delta
    CGPoint previousLocation = [touch previousLocationInView:sender];
    CGPoint location = [touch locationInView:sender];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    // move button
    CGPoint newPoint = CGPointMake(delta_x, delta_y);
    
    if (_dragHandler) {
        _dragHandler(self, newPoint);
    }
}

@end
