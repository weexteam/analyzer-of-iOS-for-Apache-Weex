//
//  WXAStorageTableView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/5.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXAStorageTableView.h"
#import "WXAStorageInfoCell.h"
#import "WXAStorageTableHeader.h"
#import "WXAUtility.h"

@interface WXAStorageTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) WXAStorageTableHeader *header;

@end

@implementation WXAStorageTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = 50;
        self.sectionHeaderHeight = 40;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[WXAStorageInfoCell class] forCellReuseIdentifier:@"infocell"];
    }
    return self;
}

#pragma mark - WXABaseContainerDelegate
- (void)onWindowSizeChanged {
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
    [self.bizDelegate onShowItemDetail:model];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WXAStorageInfoModel *model = _data[indexPath.row];
        [self.bizDelegate onRemoveItem:model];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.header;
}

#pragma mark - Getters
- (UIView *)header {
    if (!_header) {
        _header = [[WXAStorageTableHeader alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, 40)];
    }
    return _header;
}

@end
