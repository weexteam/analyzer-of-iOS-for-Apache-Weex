//
//  WXACellView.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/3/15.
//

#import "WXACellView.h"
#import "WXALogSelectItemView.h"

#define WXALOG_ITEM_WIDTH      70
#define WXALOG_ITEM_HEIGHT     28
#define WXALOG_TAG_OFFSET      100
#define WXALOG_ITEM_PADDING    8

@implementation WXACellModel

@end

@interface WXACellView ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSArray<WXALogSelectItemView *> *btns;
@property(nonatomic, strong) WXACellModel *model;

@end

@implementation WXACellView

- (instancetype)initWithFrame:(CGRect)frame model:(WXACellModel *)model {
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    // 标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.text = _model.title;
    [self addSubview:_titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
    [self addSubview:line];
    
    // 选择
    
    NSMutableArray *btns = [NSMutableArray arrayWithCapacity:_model.keys.count];
    int tag = 0;
    for (NSString* key in _model.keys) {
        NSString *title = _model.dictionary[key];
        WXALogSelectItemView *btn = [[WXALogSelectItemView alloc] initWithTitle:title selectedTitle:title];
        [btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        [btns addObject:btn];
        [self addSubview:btn];
        btn.tag = tag++;
    }
    _btns = btns;
    [self adjustSubviews];
}

- (void)adjustSubviews {
    CGFloat padding = WXALOG_ITEM_PADDING;
    CGFloat x = 0;
    CGFloat y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height+10;
    for (UIButton *btn in _btns) {
        btn.frame = CGRectMake(x, y, WXALOG_ITEM_WIDTH, WXALOG_ITEM_HEIGHT);
        
        x += WXALOG_ITEM_WIDTH + padding;
        if (x + WXALOG_ITEM_WIDTH > self.frame.size.width) {
            x = 0;
            y += padding + WXALOG_ITEM_HEIGHT;
        }
    }
    
    CGFloat height = (_btns.count > 0 ? ([_btns lastObject].frame.origin.y + [_btns lastObject].frame.size.height)+10 : y);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)selectItem:(UIButton *)sender {
    id key = _model.keys[sender.tag];
    NSMutableArray *selectedKeys = _result ? [_result mutableCopy] : [NSMutableArray new];
    if (_model.isSingle) {
        for (UIButton *btn in _btns) {
            [btn setSelected:[btn isEqual:sender]];
        }
        [selectedKeys removeAllObjects];
        [selectedKeys addObject:key];
    } else {
        sender.selected = !sender.selected;
        if (sender.selected) {
            [selectedKeys addObject:key];
        } else {
            [selectedKeys removeObject:key];
        }
    }
    _result = selectedKeys;
}

- (void)setResult:(NSArray *)result {
    _result = result;
    for (UIButton *btn in _btns) {
        id key = _model.keys[btn.tag];
        [btn setSelected:[result containsObject:key]];
    }
}

- (id)getSingelResult {
    if (_model.isSingle && _result.count > 0) {
        return _result[0];
    }
    return nil;
}

@end
