//
//  WXAIntBaseInfoViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import "WXAIntBaseInfoViewController.h"
#import "WXAIntTableViewCell.h"
#import "WXAUtility.h"
#import "WXAMonitorHandler.h"
#import "UIColor+WXAExtension.h"

@interface WXAIntBaseInfoViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSDictionary *monitor;

@end

@implementation WXAIntBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = nil;
    [self.tableView registerClass:WXAIntTableViewCell.class forCellReuseIdentifier:@"cellIdentifier"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:self.tableView];
    
    _monitor = [WXAMonitorHandler.sharedInstance.monitorDictionary[@"0"] objectForKey:@"properties"];
    
    [self fetchData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)fetchData {
    NSMutableArray *data = [NSMutableArray new];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appBaseName = [NSString stringWithFormat:@"%@ / %@", appName, appVersion];
    [data addObject:@{
                      @"key":@"应用信息",
                      @"value":appBaseName,
                      }];
    
    NSString *systemInfo = [NSString stringWithFormat:@"%@ / %@", [WXAUtility deviceModelName], [[UIDevice currentDevice] systemVersion]];
    [data addObject:@{
                      @"key":@"系统信息",
                      @"value":systemInfo,
                      }];
    
    if (_monitor) {
        NSDictionary *map = @{
                              @"wxSDKVersion":@"WeexSDK版本",
                              @"wxJSLibVersion":@"JSFM 版本",
                              @"wxBundleType":@"页面类型",
                              @"wxRequestType":@"请求类型",
                              @"wxBundleSize":@"加载bundle大小",
                              };
        for (NSString *key in map.allKeys) {
            NSString *name = [map objectForKey:key];
            NSString *value = [_monitor objectForKey:key];
            if (name && value) {
                [data addObject:@{
                                  @"key":name,
                                  @"value":value,
                                  }];
            }
        }
    }
    _data = [data copy];
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
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 100)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width-20, 100)];
    label.text = [_monitor objectForKey:@"wxBundleUrl"];
    label.textColor = UIColor.greenColor;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXAIntTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (_data.count > indexPath.row) {
        NSDictionary *data = _data[indexPath.row];
        cell.keyLabel.text = [data objectForKey:@"key"];
        cell.valueLabel.text = [data objectForKey:@"value"];
    }
    return cell;
}

@end
