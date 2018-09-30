//
//  WXAIntBaseInfoViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import "WXAIntBaseInfoViewController.h"
#import "WXAIntTableViewCell.h"
#import "WXAUtility.h"
#import "WXAMonitorDataManager.h"
#import "UIColor+WXAExtension.h"

@interface WXAIntBaseInfoViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSDictionary *monitor;

@end

@implementation WXAIntBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSString *)type {
    return @"properties";
}

- (void)load {
    _monitor = [WXAMonitorDataManager.sharedInstance.monitorDictionary[self.instanceId] objectForKey:@"properties"];
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
        NSArray *allkeys = [map.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        for (NSString *key in allkeys) {
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

- (void)reload {
    [self load];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
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
