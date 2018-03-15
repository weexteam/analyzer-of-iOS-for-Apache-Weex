//
//  WXAMenuCell.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/3/8.
//  Copyright © 2018年 Taobao. All rights reserved.
//

#import "WXAMenuCell.h"

@implementation WXAMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/4, frame.size.height/4, frame.size.width*0.4, frame.size.height*0.4) ];
        [self addSubview:_icon];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*3/4, frame.size.width, frame.size.height/4)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:10];
        _label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [self addSubview:_label];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

@end
