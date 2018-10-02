//
//  WXAPageTabbar.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import "WXAPageTabbar.h"
#import "WXAUtility.h"
#import "UIColor+WXAExtension.h"

@interface WXAPageTabbar ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) UIView* topLine;

@end

@implementation WXAPageTabbar

- (instancetype)initWithFrame:(CGRect)frame tabs:(NSArray<NSString*>*)tabs
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = INT_MAX;
        _buttons = [NSMutableArray new];
        NSArray *array = [tabs copy];;
        int index = 0;
        CGFloat width = self.bounds.size.width;
        for (NSString *item in array) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(index*width/array.count, 0, width/array.count, self.bounds.size.height)];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitle:item forState:UIControlStateNormal];
            [button setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
            [button setTitleColor:UIColor.wxaHighlightColor forState:UIControlStateSelected];
            button.backgroundColor = UIColor.clearColor;
            [button addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = index;
            [self addSubview:button];
            [_buttons addObject:button];
            index++;
        }
        
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1/UIScreen.mainScreen.scale)];
        _topLine.backgroundColor = UIColor.lightGrayColor;
        [self addSubview:_topLine];
    }
    return self;
}

- (void)setCurrent:(NSUInteger)index {
    if (index != _currentIndex) {
        if (_currentIndex != INT_MAX) {
            UIButton *lastButton = [_buttons objectAtIndex:_currentIndex];
            lastButton.selected = NO;
        }
        UIButton *button = [_buttons objectAtIndex:index];
        button.selected = YES;
        _currentIndex = index;
    }
}

- (NSUInteger)getCurrent
{
    return _currentIndex;
}

- (void)pressButton:(UIButton *)button {
    if (button.tag != _currentIndex) {
        if (self.select) {
            self.select(button.tag, _currentIndex);
            [self setCurrent:button.tag];
        }
    }
    
}

- (void)hideTopLine
{
    _topLine.hidden = YES;
}

@end
