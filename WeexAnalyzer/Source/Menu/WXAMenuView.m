//
//  WXAMenuView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXAMenuView.h"
#import "UIView+WXAPopover.h"
#import "WXAUtility.h"

@interface WXAMenuView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSArray<WXAMenuItem *> *items;

@end

@implementation WXAMenuView

- (instancetype)initWithItems:(NSArray<WXAMenuItem *> *)items {
    if (self = [super init]) {
        _items = items;
        [self initMenu];
    }
    return self;
}

- (void)initMenu {
    CGRect frame = [UIScreen mainScreen].bounds;
    self.frame = frame;
    
    _maskView = [[UIView alloc] initWithFrame:frame];
    _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:_maskView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake((frame.size.width-260)/2, (frame.size.height-300)/2, 260, 300) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.layer.cornerRadius = 10.0f;
    _tableView.rowHeight = 44;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.clipsToBounds = YES;
    _tableView.sectionHeaderHeight = 44;
    [self addSubview:_tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
    tap.delegate = self;
    [_maskView addGestureRecognizer:tap];
}

- (void)showMenu {
    __weak typeof(self) welf = self;
    [self WeexAnalyzer_popover:^{
        welf.maskView.alpha = 0;
        welf.tableView.frame = CGRectMake(welf.tableView.frame.origin.x, WXA_SCREEN_HEIGHT, welf.tableView.frame.size.width, welf.tableView.frame.size.height);
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            welf.tableView.frame = CGRectMake(welf.tableView.frame.origin.x, (WXA_SCREEN_HEIGHT - 300) / 2, welf.tableView.frame.size.width, welf.tableView.frame.size.height);
            welf.maskView.alpha = 0.5;
        }                completion:nil];
    }];
}

- (void)closeMenu:(UITapGestureRecognizer *)tap {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXAMenuItem *item = _items[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menucell"];
    cell.textLabel.text = item.title;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, _tableView.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WXAMenuItem *item = _items[indexPath.row];
    if (item.handler) {
        item.handler(YES);
    }
    [self closeMenu:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 44)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:header.bounds];
    label.text = @"Weex Analyzer";
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [header addSubview:label];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, label.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [header addSubview:line];
    return header;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
