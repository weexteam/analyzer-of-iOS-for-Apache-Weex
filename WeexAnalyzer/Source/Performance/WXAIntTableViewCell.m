//
//  WXAIntTableViewCell.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import "WXAIntTableViewCell.h"
#import "UIColor+WXAExtension.h"

@implementation WXAIntTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.font = [UIFont systemFontOfSize:14];
        _keyLabel.textColor = UIColor.wxaHighlightColor;
        [self.contentView addSubview:_keyLabel];
        
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont systemFontOfSize:14];
        _valueLabel.textColor = UIColor.whiteColor;
        _valueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_valueLabel];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _keyLabel.frame = CGRectMake(20, 0, self.bounds.size.width-120, self.bounds.size.height);
    _valueLabel.frame = CGRectMake(100, 0, self.bounds.size.width - 120, self.bounds.size.height);
    
}

@end
