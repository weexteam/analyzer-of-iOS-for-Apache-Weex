//
//  WXAStorageTableHeader.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/3.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAStorageTableHeader.h"
#import "WXAUtility.h"

@interface WXAStorageTableHeader ()

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *persistentLabel;

@end

@implementation WXAStorageTableHeader {
    CGRect _keyLabelFrame;
    CGRect _sizeLabelFrame;
    CGRect _timeLabelFrame;
    CGRect _persistentLabelFrame;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGFloat sizeWidth = 80;
    CGFloat persistentWidth = 40;
    CGFloat padding = 8;
    CGFloat keyWidth = (WXA_SCREEN_WIDTH-5*padding-sizeWidth-persistentWidth)/2;
    CGFloat timeWidth = keyWidth;
    _keyLabelFrame = CGRectMake(padding, 0, keyWidth, 40);
    _sizeLabelFrame = CGRectMake(padding*2+keyWidth, 0, sizeWidth, 40);
    _timeLabelFrame = CGRectMake(padding *3+keyWidth+sizeWidth, 0, timeWidth, 40);
    _persistentLabelFrame = CGRectMake(padding*4+keyWidth+sizeWidth+timeWidth, 0, persistentWidth, 40);
    
    [self addSubview:self.keyLabel];
    [self addSubview:self.sizeLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.persistentLabel];
}

#pragma mark - Setters
- (UILabel *)keyLabel {
    if (!_keyLabel) {
        _keyLabel = [[UILabel alloc] initWithFrame:_keyLabelFrame];
        _keyLabel.textColor = [UIColor darkGrayColor];
        _keyLabel.font = [UIFont systemFontOfSize:15];
        _keyLabel.text = @"key";
        _keyLabel.numberOfLines = 2;
    }
    return _keyLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] initWithFrame:_sizeLabelFrame];
        _sizeLabel.textColor = [UIColor darkGrayColor];
        _sizeLabel.font = [UIFont systemFontOfSize:14];
        _sizeLabel.text = @"大小";
        _sizeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sizeLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:_timeLabelFrame];
        _timeLabel.textColor = [UIColor darkGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.numberOfLines = 2;
        _timeLabel.text = @"最近更新时间";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)persistentLabel {
    if (!_persistentLabel) {
        _persistentLabel = [[UILabel alloc] initWithFrame:_persistentLabelFrame];
        _persistentLabel.textColor = [UIColor darkGrayColor];
        _persistentLabel.font = [UIFont systemFontOfSize:14];
        _persistentLabel.numberOfLines = 2;
        _persistentLabel.textAlignment = NSTextAlignmentCenter;
        _persistentLabel.text = @"持久";
    }
    return _persistentLabel;
}

@end
