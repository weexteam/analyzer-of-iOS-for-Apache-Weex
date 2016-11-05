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
#import "WXAStorageBar.h"
#import "WXAUtility.h"
#import "WXAStorageTableHeader.h"
#import "WXAStorageDetailView.h"
#import "UIView+WXAPopover.h"

#define WXALOG_SORTBAR_HEIGHT   40

@interface WXAStorageContainer () <UITableViewDataSource, UITableViewDelegate, WXAStorageBarDelegate, WXAStorageDetailViewDelegate>

@property (nonatomic, strong) WXAStorageBar *bar;
@property (nonatomic, strong) WXAStorageTableHeader *header;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<WXAStorageInfoModel *> *data;
@property (nonatomic, strong) WXAStorageDetailView *detailView;

@property (nonatomic, strong) WXAStorageResolver *resolver;

@end

@implementation WXAStorageContainer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 0.5;
        
        [self addSubview:self.bar];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)refreshData {
    self.data = [self.resolver getStorageInfoList];
    [self.tableView reloadData];
}

- (void)showDetail:(WXAStorageInfoModel *)model {
    __weak typeof(self) welf = self;
    [_resolver getItem:model.key callback:^(BOOL success, NSString *result) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                welf.detailView.itemValue = result;
                [welf.detailView showInView:welf];
            });
        }
    }];
}

#pragma mark - WXAStorageBarDelegate
- (void)onCloseWindow {
    [self.delegate onCloseWindow];
}

- (void)clearAll {
    for (WXAStorageInfoModel *model in self.data) {
        [_resolver removeItem:model.key callback:nil];
    }
    [self refreshData];
}

- (void)refreshAll {
    [self refreshData];
}

#pragma mark - WXAStorageDetailViewDelegate
- (void)onCloseDetailWindow {
    [_detailView removeFromSuperview];
    _detailView = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXAStorageInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infocell" forIndexPath:indexPath];
    cell.model = _data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WXAStorageInfoModel *model = _data[indexPath.row];
    [self showDetail:model];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WXAStorageInfoModel *model = _data[indexPath.row];
        [self.resolver removeItem:model.key callback:nil];
        
        self.data = [self.resolver getStorageInfoList];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.header;
}

#pragma mark - Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WXALOG_SORTBAR_HEIGHT, WXA_SCREEN_WIDTH, self.frame.size.height-WXALOG_SORTBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        _tableView.sectionHeaderHeight = 40;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WXAStorageInfoCell class] forCellReuseIdentifier:@"infocell"];
    }
    return _tableView;
}

- (WXAStorageBar *)bar {
    if (!_bar) {
        _bar = [[WXAStorageBar alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, WXALOG_SORTBAR_HEIGHT) hostView:self];
        _bar.delegate = self;
    }
    return _bar;
}

- (WXAStorageDetailView *)detailView {
    if (!_detailView) {
        _detailView = [[WXAStorageDetailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _detailView.delegate = self;
    }
    return _detailView;
}

- (WXAStorageResolver *)resolver {
    if (!_resolver) {
        _resolver = [[WXAStorageResolver alloc] init];
        
        /*
        [_resolver setItem:@"key1" value:@"1234" callback:^(BOOL success) {
            NSLog(@"---%@",@(success));
        }];
        [_resolver setItem:@"key2" value:@"56789" callback:^(BOOL success) {
            NSLog(@"---%@",@(success));
        }];*/
    }
    return _resolver;
}

- (UIView *)header {
    if (!_header) {
        _header = [[WXAStorageTableHeader alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, 40)];
    }
    return _header;
}

@end
