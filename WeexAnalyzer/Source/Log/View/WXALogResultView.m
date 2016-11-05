//
//  WXALogResultView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/27.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogResultView.h"
#import "WXALogResultCell.h"

@interface WXALogResultView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation WXALogResultView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        _autoScroll = YES;
        [self registerClass:[WXALogResultCell class] forCellReuseIdentifier:@"logcell"];
    }
    return self;
}

#pragma mark - public methods
- (void)reloadResults {
    [self reloadData];
    if (_autoScroll && self.data.count > 0) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:self.data.count-1 inSection:0];
        [self scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)insertLastRow:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.data.count-1 inSection:0];
    if (animated) {
        [self beginUpdates];
        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self endUpdates];
    } else {
        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    if (_autoScroll) {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"logcell";
    WXALogResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.log = [_data objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WXALogResultCell estimatedHeightForLog:_data[indexPath.row]];
}

//允许长按菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//允许每一个Action
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (action == @selector(copy:)) {//如果操作为复制
        return YES;
    }
    return NO;
}

//对一个给定的行告诉代表执行复制或粘贴操作内容,
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (action == @selector(copy:)) {//如果操作为复制
        WXALogModel *log = _data[indexPath.row];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];//黏贴板
            [pasteBoard setString:log.message];
        });
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
    }
    return nil;
}

@end
