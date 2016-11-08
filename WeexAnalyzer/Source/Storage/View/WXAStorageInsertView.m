//
//  WXAStorageInsertView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#define WXASTORAGE_INSERT_KEY_HEIGHT        30
#define WXASTORAGE_INSERT_BOTTOM_HEIGHT     40
#define WXASTORAGE_INSERT_PERSISTENT_WIDTH  60

#import "WXAStorageInsertView.h"
#import "WXALogSelectItemView.h"

@interface WXAStorageInsertView ()

@property (nonatomic, strong) UITextField *keyTF;
@property (nonatomic, strong) UITextView *valueView;
@property (nonatomic, strong) WXALogSelectItemView *persitentItem;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, copy) void(^handler)(WXAStorageItemModel *item);

@end

@implementation WXAStorageInsertView

- (instancetype)initWithFrame:(CGRect)frame
                   hostOption:(WXAOptionButton *)hostOption
                      handler:(void (^)(WXAStorageItemModel *))handler {
    if (self = [super initWithFrame:frame hostOption:hostOption]) {
        _handler = handler;
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self addSubview:self.keyTF];
        [self addSubview:self.persitentItem];
        [self addSubview:self.valueView];
        [self addSubview:self.confirmBtn];
    }
    return self;
}

#pragma mark - actions
- (void)confirmAction:(id)sender {
    if (_keyTF.text.length == 0) {
        return;
    }
    
    if (_valueView.text.length == 0) {
        return;
    }
    
    WXAStorageItemModel *item = [WXAStorageItemModel new];
    item.key = _keyTF.text;
    item.value = _valueView.text;
    item.persistent = _persitentItem.selected;
    
    if (self.handler) {
        self.handler(item);
    }
}

- (void)tooglePersistent:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - Getters
- (UITextField *)keyTF {
    if (!_keyTF) {
        _keyTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20-WXASTORAGE_INSERT_PERSISTENT_WIDTH-10, WXASTORAGE_INSERT_KEY_HEIGHT)];
        _keyTF.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        _keyTF.layer.cornerRadius = 3;
        _keyTF.layer.masksToBounds = YES;
        _keyTF.textColor = [UIColor darkGrayColor];
        _keyTF.font = [UIFont systemFontOfSize:14];
        _keyTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _keyTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _keyTF.placeholder = @"key";
    }
    return _keyTF;
}

- (UITextView *)valueView {
    if (!_valueView) {
        _valueView = [[UITextView alloc] initWithFrame:CGRectMake(10, WXASTORAGE_INSERT_KEY_HEIGHT+18, self.frame.size.width-20, self.frame.size.height-WXASTORAGE_INSERT_KEY_HEIGHT-28-WXASTORAGE_INSERT_BOTTOM_HEIGHT)];
        _valueView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        _valueView.layer.cornerRadius = 3;
        _valueView.layer.masksToBounds = YES;
        _valueView.autocorrectionType = UITextAutocorrectionTypeNo;
        _valueView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _valueView.textColor = [UIColor darkGrayColor];
        _valueView.font = [UIFont systemFontOfSize:14];
    }
    return _valueView;
}

- (WXALogSelectItemView *)persitentItem {
    if (!_persitentItem) {
        _persitentItem = [[WXALogSelectItemView alloc] initWithTitle:@"持久" selectedTitle:@"持久"];
        _persitentItem.frame = CGRectMake(self.frame.size.width-WXASTORAGE_INSERT_PERSISTENT_WIDTH-10, 10, WXASTORAGE_INSERT_PERSISTENT_WIDTH, WXASTORAGE_INSERT_KEY_HEIGHT);
        [_persitentItem addTarget:self action:@selector(tooglePersistent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _persitentItem;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(10, self.frame.size.height - WXASTORAGE_INSERT_BOTTOM_HEIGHT, self.frame.size.width-20, WXASTORAGE_INSERT_BOTTOM_HEIGHT-5);
        _confirmBtn.backgroundColor = [UIColor orangeColor];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _confirmBtn.layer.cornerRadius = 3;
        _confirmBtn.layer.masksToBounds = YES;
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
