//
//  WXAPerformanceView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXAPerformanceView.h"
#import "WXAUtility.h"
#import "WXAPerformanceCell.h"
#import "UIView+WXAPopover.h"

#define WXAPERFORMANCE_CONTAINER_WIDTH  300
#define WXAPERFORMANCE_CONTAINER_HEIGHT 400

@interface WXAPerformanceView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *container;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *copyBtn;

@end

@implementation WXAPerformanceView

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self addSubview:self.maskView];
        [self addSubview:self.container];
    }
    return self;
}

#pragma mark - public methods
- (void)show {
    __weak typeof(self) welf = self;
    [self WeexAnalyzer_popover:^{
        welf.maskView.alpha = 0;
        welf.container.transform = CGAffineTransformMakeTranslation(0, welf.frame.size.height);
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            welf.container.transform = CGAffineTransformIdentity;
            welf.maskView.alpha = 0.5;
        } completion:nil];
    }];
}

- (void)hide {
    [self removeFromSuperview];
}

#pragma mark - private methods
- (void)maskCloseWindow {
    [self hide];
}

- (void)copyAction:(id)sender {
    NSMutableString *str = [NSMutableString string];
    for (NSArray<WXAPerformanceModel *> *array in self.data) {
        for (WXAPerformanceModel *model in array) {
            [str appendFormat:@"%@: %@\n", model.title, model.value];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];//黏贴板
        [pasteBoard setString:str];
    });
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray<WXAPerformanceModel *> *array = self.data[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<WXAPerformanceModel *> *array = self.data[indexPath.section];

    WXAPerformanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"perfcell" forIndexPath:indexPath];
    cell.model = array[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<WXAPerformanceModel *> *array = self.data[indexPath.section];

    WXAPerformanceModel *model = array[indexPath.row];
    CGFloat height = [WXAPerformanceCell estimateCellHeight:model containerWidth:_container.frame.size.width];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray<WXAPerformanceModel *> *array = self.data[section];
    if (!array || array.count == 0) {
        return 0;
    }
    
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray<WXAPerformanceModel *> *array = self.data[section];
    if (!array || array.count == 0) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, 20)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
    label.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    label.text = [NSString stringWithFormat:@"   %@",[WXAPerformanceModel categoryToStr:array[0].category]];
    return label;
}

//允许 Menu菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//每个cell都会点击出现Menu菜单
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return action == @selector(copy:);
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        [UIPasteboard generalPasteboard].string = self.data[indexPath.section][indexPath.row].value;
    }
}

#pragma mark - Setters
- (void)setData:(NSArray<NSArray<WXAPerformanceModel *> *> *)data {
    _data = data;
    [self.container reloadData];
}

#pragma mark - Getters
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskCloseWindow)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UITableView *)container {
    if (!_container) {
        _container = [[UITableView alloc] initWithFrame:CGRectMake((WXA_SCREEN_WIDTH-WXAPERFORMANCE_CONTAINER_WIDTH)/2, (WXA_SCREEN_HEIGHT-WXAPERFORMANCE_CONTAINER_HEIGHT)/2, WXAPERFORMANCE_CONTAINER_WIDTH, WXAPERFORMANCE_CONTAINER_HEIGHT) style:UITableViewStylePlain];
        _container.dataSource = self;
        _container.delegate = self;
        _container.tableFooterView = [UIView new];
        _container.tableHeaderView = self.headerView;
        _container.layer.cornerRadius = 5;
        _container.layer.masksToBounds = YES;
        [_container registerClass:[WXAPerformanceCell class] forCellReuseIdentifier:@"perfcell"];
    }
    return _container;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.container.frame.size.width, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:_headerView.bounds];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Weex性能指标";
        [_headerView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, _headerView.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [_headerView addSubview:line];
        
        [_headerView addSubview:self.copyBtn];
    }
    return _headerView;
}

- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _copyBtn.frame = CGRectMake(5, 0, 40, 40);
        [_copyBtn setTitle:@"copy" forState:UIControlStateNormal];
        [_copyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_copyBtn addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
        _copyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _copyBtn;
}

@end
