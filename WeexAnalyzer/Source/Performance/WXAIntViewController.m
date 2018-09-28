//
//  WXAIntViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import "WXAIntViewController.h"
#import "WXAMonitorDataManager.h"
#import "UIColor+WXAExtension.h"
#import "WXAUtility.h"

@interface WXAIntViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *warningData;

@end

@implementation WXAIntViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = nil;
    [tableView registerClass:WXAInteractionTableViewCell.class forCellReuseIdentifier:@"cellIdentifier"];
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tableView];
    self.contentView = tableView;
    
}

- (NSString *)type {
    return @"wxinteraction";
}

- (void)load {
    _data = [WXAMonitorDataManager.sharedInstance.monitorDictionary[@"0"] objectForKey:@"wxinteraction"];
    NSMutableArray *data = [NSMutableArray new];
    if (_data) {
        for (NSDictionary *item in _data) {
            NSNumber *renderDiffTime= [item objectForKey:@"renderDiffTime"];
            if([renderDiffTime isKindOfClass:NSNumber.class] && renderDiffTime.doubleValue > 200) {
                [data addObject:item];
            }
        }
    } else {
        _data = @[@{@"type":@"div",@"ref":@"21",@"renderDiffTime":@300}];
    }
    _warningData = [data copy];
}

- (void)reload {
    [self load];
    [(UITableView *)self.contentView reloadData];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width/2, 40)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitle:@"全部节点" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.wxaHighlightColor forState:UIControlStateSelected];
    button.selected = YES;
    [headerView addSubview:button];
    
    UIButton *warning = [[UIButton alloc] initWithFrame:CGRectMake(tableView.bounds.size.width/2, 0, tableView.bounds.size.width/2, 40)];
    warning.titleLabel.font = [UIFont systemFontOfSize:13];
    [warning setTitle:@"超时节点" forState:UIControlStateNormal];
    [warning setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
    [warning setTitleColor:UIColor.wxaHighlightColor forState:UIControlStateSelected];
    [headerView addSubview:warning];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 60, 20)];
    time.text = @"耗时";
    time.textColor = UIColor.whiteColor;
    time.textAlignment = NSTextAlignmentCenter;
    time.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:time];
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 60, 20)];
    info.text = @"节点";
    info.textColor = UIColor.whiteColor;
    info.textAlignment = NSTextAlignmentCenter;
    info.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:info];
    
    UILabel *attr = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, UIScreen.mainScreen.bounds.size.width-120, 20)];
    attr.text = @"属性/样式";
    attr.textColor = UIColor.whiteColor;
    attr.textAlignment = NSTextAlignmentCenter;
    attr.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:attr];
    
    UIView *hline3 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, WXA_SCREEN_WIDTH, WXA_SCREEN_1PIXCEL)];
    hline3.backgroundColor = UIColor.whiteColor;
    [headerView addSubview:hline3];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXAInteractionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (_data.count > indexPath.row) {
        NSDictionary *data = _data[indexPath.row];
        cell.typeLabel.text = [data objectForKey:@"type"];
        cell.refLabel.text = [data objectForKey:@"ref"];
        cell.styleLabel.text = [data objectForKey:@"styleString"];
        cell.attrsLabel.text = [data objectForKey:@"attrsString"];
        cell.diffTimeLabel.text = [NSString stringWithFormat:@"+%@ms", [data objectForKey:@"renderDiffTime"] ?: @0];
    }
    return cell;
}

@end

@implementation WXAInteractionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat width = UIScreen.mainScreen.bounds.size.width;
        
        _diffTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _diffTimeLabel.font = [UIFont systemFontOfSize:12];
        _diffTimeLabel.textColor = UIColor.whiteColor;
        _diffTimeLabel.backgroundColor = UIColor.wxaHighlightRectColor;
        _diffTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_diffTimeLabel];
        
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 60, 30)];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.textColor = UIColor.whiteColor;
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_typeLabel];
        
        _refLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 60, 30)];
        _refLabel.font = [UIFont systemFontOfSize:12];
        _refLabel.textColor = UIColor.whiteColor;
        _refLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_refLabel];
        
        _styleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, width-140, 30)];
        _styleLabel.font = [UIFont systemFontOfSize:10];
        _styleLabel.textColor = UIColor.whiteColor;
        _styleLabel.numberOfLines = 2;
        [self.contentView addSubview:_styleLabel];
        
        _attrsLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, width-140, 30)];
        _attrsLabel.font = [UIFont systemFontOfSize:10];
        _attrsLabel.textColor = UIColor.whiteColor;
        _attrsLabel.numberOfLines = 2;
        [self.contentView addSubview:_attrsLabel];
        
        UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(120, 5, 1/UIScreen.mainScreen.scale, 50)];
        vline.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:vline];
        
        UIView *hline1 = [[UIView alloc] initWithFrame:CGRectMake(65, 30, 50, 1/UIScreen.mainScreen.scale)];
        hline1.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:hline1];
        
        UIView *hline2 = [[UIView alloc] initWithFrame:CGRectMake(125, 30, width-135, 1/UIScreen.mainScreen.scale)];
        hline2.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:hline2];
        
        UIView *hline3 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, width, 1/UIScreen.mainScreen.scale)];
        hline3.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:hline3];
        
    }
    
    return self;
}

@end
