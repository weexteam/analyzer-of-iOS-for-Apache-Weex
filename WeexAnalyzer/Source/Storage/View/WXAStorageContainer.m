//
//  WXAStorageContainer.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/2.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAStorageContainer.h"
#import "WXAStorageResolver.h"
#import "WXAStorageInfoCell.h"
#import "WXAUtility.h"
#import "WXAStorageTableHeader.h"
#import "WXAStorageDetailView.h"
#import "UIView+WXAPopover.h"
#import "WXAStorageTableView.h"
#import "WXAStorageInsertView.h"

#define WXASTORAGE_OPTIONS_VIEW_HEIGHT  170

@interface WXAStorageContainer () <WXAStorageTableViewDelegate>

@property (nonatomic, strong) WXAStorageTableView *tableView;
@property (nonatomic, strong) NSArray<WXAStorageInfoModel *> *data;

@property (nonatomic, strong) WXAStorageResolver *resolver;

@end

@implementation WXAStorageContainer

- (instancetype)initWithWindowType:(WXALogWindowType)windowType {
    if (self = [super initWithWindowType:windowType]) {
        self.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 0.5;
        
        [self initOptions];
        [self.contentView addSubview:self.tableView];
        __weak typeof(self) welf = self;
        self.contentView.onContentSizeChanged = ^(CGRect frame) {
            welf.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        };
    }
    return self;
}

- (void)initOptions {
    __weak typeof(self) welf = self;
    
    [self.optionBar addOption:[[WXAOptionButton alloc] initWithTitle:@"刷新"
                                                        clickHandler:^(UIButton *button) {
                                                            [welf refreshData];
                                                        }]];
    
    [self.optionBar addOption:[[WXAOptionButton alloc] initWithTitle:@"添加 ↓"
                                                       selectedTitle:@"添加 ↑"
                                                        clickHandler:^(UIButton *button) {
                                                            [welf showAddItem:button];
                                                        }]];

    [self.optionBar addOption:[[WXAOptionButton alloc] initWithTitle:@"清空"
                                                        clickHandler:^(UIButton *button) {
                                                            [welf clearAll];
                                                        }]];
    
    [self.optionBar addDefaultOption:WXADefaultOptionTypeDrag];
    [self.optionBar addDefaultOption:WXADefaultOptionTypeSwitchSize];
    [self.optionBar addDefaultOption:WXADefaultOptionTypeCloseWindow];
}

#pragma mark - actions
- (void)refreshData {
    self.data = [self.resolver getStorageInfoList];
    self.tableView.data = self.data;
    
    __weak typeof(self) welf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [welf.tableView reloadData];
    });
}

- (void)showAddItem:(UIButton *)sender {
    if (sender.selected) {
        [self closeOptionView:YES];
        return;
    }
    
    CGRect frame = self.contentView.frame;
    __weak typeof(self) welf = self;
    WXAStorageInsertView *optionView =
        [[WXAStorageInsertView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, WXASTORAGE_OPTIONS_VIEW_HEIGHT)
                                         hostOption:(WXAOptionButton *)sender
                                            handler:^(WXAStorageItemModel *item) {
                                                [welf closeOptionView:YES];
                                                [welf addItem:item];
                                            }];
    [self showOptionView:optionView];
}

- (void)clearAll {
    dispatch_group_t removeGroup = dispatch_group_create();
    
    for (WXAStorageInfoModel *model in self.data) {
        dispatch_group_enter(removeGroup);
        [_resolver removeItem:model.key callback:^(BOOL success) {
            dispatch_group_leave(removeGroup);
        }];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_notify(removeGroup, dispatch_get_main_queue(), ^{
        [weakSelf refreshData];
    });
}

- (void)addItem:(WXAStorageItemModel *)item {
    __weak typeof(self) weakSelf = self;
    [_resolver setItem:item.key value:item.value persistent:item.persistent callback:^(BOOL success) {
        [weakSelf refreshData];
    }];
}

#pragma mark - WXAStorageTableViewDelegate
- (void)onShowItemDetail:(WXAStorageInfoModel *)model {
    __weak typeof(self) welf = self;
    [_resolver getItem:model.key callback:^(BOOL success, NSString *result) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                WXAStorageDetailView *detailView = [[WXAStorageDetailView alloc] initWithFrame:self.bounds];
                detailView.itemValue = result;
                [detailView showInView:welf];
            });
        }
    }];
}

- (void)onRemoveItem:(WXAStorageInfoModel *)model {
    __weak typeof(self) welf = self;
    [self.resolver removeItem:model.key callback:^(BOOL success) {
        [welf refreshData];
    }];
}

#pragma mark - Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[WXAStorageTableView alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, self.contentView.frame.size.height) style:UITableViewStylePlain];
        _tableView.bizDelegate = self;
    }
    return _tableView;
}

- (WXAStorageResolver *)resolver {
    if (!_resolver) {
        _resolver = [[WXAStorageResolver alloc] init];
    }
    return _resolver;
}

@end
