//
//  WXAIntViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import "WXAIntViewController.h"
#import "WXAMonitorHandler.h"
#import "UIColor+WXAExtension.h"

@interface WXAIntViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *warningData;
@property (nonatomic, strong) NSArray *monitor;

@end

@implementation WXAIntViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = nil;
    [self.tableView registerClass:WXAInteractionTableViewCell.class forCellReuseIdentifier:@"cellIdentifier"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
    
    _monitor = [WXAMonitorHandler.sharedInstance.monitorDictionary[@"0"] objectForKey:@"wxinteraction"];
    
    [self fetchData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)fetchData {
    NSMutableArray *data = [NSMutableArray new];
    if (_monitor) {
        for (NSDictionary *item in _monitor) {
            NSNumber *renderDiffTime= [item objectForKey:@"renderDiffTime"];
            if([renderDiffTime isKindOfClass:NSNumber.class] && renderDiffTime.doubleValue > 200) {
                [data addObject:item];
            }
        }
    } else {
        _monitor = @[@{@"type":@"div",@"ref":@"21",@"renderDiffTime":@300}];
    }
    _warningData = [data copy];
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
    return _monitor.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXAInteractionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (_monitor.count > indexPath.row) {
        NSDictionary *data = _monitor[indexPath.row];
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
        _diffTimeLabel.backgroundColor = UIColor.wxaHighlightColor;
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
