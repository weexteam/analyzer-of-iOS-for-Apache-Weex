//
//  WXAStorageInfoCell.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAStorageInfoCell.h"
#import "WXAUtility.h"

@interface WXAStorageInfoCell ()

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *persistentLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation WXAStorageInfoCell {
    CGRect _keyLabelFrame;
    CGRect _sizeLabelFrame;
    CGRect _timeLabelFrame;
    CGRect _persistentLabelFrame;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    _keyLabelFrame = CGRectMake(padding, 0, keyWidth, 50);
    _sizeLabelFrame = CGRectMake(padding*2+keyWidth, 0, sizeWidth, 50);
    _timeLabelFrame = CGRectMake(padding *3+keyWidth+sizeWidth, 0, timeWidth, 50);
    _persistentLabelFrame = CGRectMake(padding*4+keyWidth+sizeWidth+timeWidth, 0, persistentWidth, 50);

    [self.contentView addSubview:self.keyLabel];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.persistentLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)setModel:(WXAStorageInfoModel *)model {
    _model = model;
    
    self.keyLabel.text = model.key;
    self.sizeLabel.text = model.sizeStr;
    self.timeLabel.text = model.timeStr;
    self.persistentLabel.text = (model.persistent ? @"✔️": @"");
}

#pragma mark - Setters
- (UILabel *)keyLabel {
    if (!_keyLabel) {
        _keyLabel = [[UILabel alloc] initWithFrame:_keyLabelFrame];
        _keyLabel.textColor = [UIColor darkGrayColor];
        _keyLabel.font = [UIFont systemFontOfSize:15];
        _keyLabel.numberOfLines = 2;
    }
    return _keyLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] initWithFrame:_sizeLabelFrame];
        _sizeLabel.textColor = [UIColor darkGrayColor];
        _sizeLabel.font = [UIFont systemFontOfSize:14];
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
    }
    return _persistentLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, WXA_SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    return _lineView;
}

@end
