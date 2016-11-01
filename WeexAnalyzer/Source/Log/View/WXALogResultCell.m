//
//  WXALogResultCell.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogResultCell.h"
#import "WXAUtility.h"

@interface WXALogResultCell ()

@property (nonatomic, strong) UILabel *logLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation WXALogResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, WXA_SCREEN_WIDTH-10, 0)];
    _logLabel.font = [UIFont systemFontOfSize:12];
    _logLabel.textColor = [UIColor darkGrayColor];
    _logLabel.numberOfLines = 0;
    [self addSubview:_logLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, 0.5)];
    _lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self addSubview:_lineView];
}

- (void)setLog:(WXALogModel *)log {
    _log = log;
    
    _logLabel.text = log.message;
    NSDictionary *attribute = @{NSFontAttributeName: _logLabel.font};
    CGSize size = [log.message boundingRectWithSize:CGSizeMake(WXA_SCREEN_WIDTH-10, 500)
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;
    _logLabel.frame = CGRectMake(_logLabel.frame.origin.x, 3, WXA_SCREEN_WIDTH-10, (NSInteger)(size.height+1));
    
    if (log.flag == WXLogFlagError) {
        _logLabel.textColor =  [UIColor colorWithRed:220/255.0 green:20/255.0 blue:60/255.0 alpha:1];
    } else if (log.flag == WXLogFlagWarning) {
        _logLabel.textColor =  [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1];
    } else {
        _logLabel.textColor = [UIColor darkGrayColor];
    }
    
    _lineView.frame = CGRectMake(0, _logLabel.frame.origin.y+_logLabel.frame.size.height+2.5, WXA_SCREEN_WIDTH, 0.5);
}

+ (CGFloat)estimatedHeightForLog:(WXALogModel *)log {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
    CGSize size = [log.message boundingRectWithSize:CGSizeMake(WXA_SCREEN_WIDTH-10, 500)
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;
    return (NSInteger)size.height+7;
}

@end
