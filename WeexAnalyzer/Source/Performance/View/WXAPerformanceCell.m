//
//  WXAPerformanceCell.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/29.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAPerformanceCell.h"

@interface WXAPerformanceCell ()

@property (nonatomic, strong) UILabel *performLabel;

@end

@implementation WXAPerformanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.performLabel];
    }
    return self;
}

#pragma mark - Setters
- (void)setModel:(WXAPerformanceModel *)model {
    _model = model;
    
    NSString *msg = [NSString stringWithFormat:@"%@: %@", model.title, model.value];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:msg];
    NSDictionary *attributeDict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:70/255.0 green:130/255.0 blue:180/255.0 alpha:1]};
    [content setAttributes:attributeDict range:NSMakeRange(model.title.length+1, msg.length - model.title.length-1)];
    
    self.performLabel.attributedText = content;
    NSDictionary *attribute = @{NSFontAttributeName: self.performLabel.font};
    CGFloat height = [msg boundingRectWithSize:CGSizeMake(self.frame.size.width-10, 500)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size.height;
    height+=8;
    self.performLabel.frame = CGRectMake(10, 0, self.frame.size.width-10, height);
}

#pragma mark - Getters
- (UILabel *)performLabel {
    if (!_performLabel) {
        _performLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 0)];
        _performLabel.font = [UIFont systemFontOfSize:12];
        _performLabel.textColor = [UIColor darkGrayColor];
        _performLabel.numberOfLines = 0;
    }
    return _performLabel;
}

+ (CGFloat)estimateCellHeight:(WXAPerformanceModel *)model containerWidth:(CGFloat)width {
    NSString *msg = [NSString stringWithFormat:@"%@: %@", model.title, model.value];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
    CGFloat height = [msg boundingRectWithSize:CGSizeMake(width-10, 500)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size.height;
    return height+8;
}

@end
