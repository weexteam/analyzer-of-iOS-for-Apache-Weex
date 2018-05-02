//
//  WXAPerformanceViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/4/10.
//

#import "WXAPerformanceViewController.h"
#import "WXAMonitorHandler.h"
#import "WXAPerformanceCell.h"

@implementation WXAPerformanceData
@end

@implementation WXAPerformanceViewController

- (void)viewDidLoad {
    self.title = @"性能指标";
    [super viewDidLoad];
    
    self.data = [NSMutableArray new];
    [self.tableView registerClass:[WXAPerformanceCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    [self addBarItemWith:@"清空" action:@selector(clear) to:self];
    
    [self refreshData];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(refreshData) name:kWXAMonitorHandlerNotification object:nil];
}

- (void)clear {
    [[WXAMonitorHandler sharedInstance].monitorDictionary removeAllObjects];
    [self refreshData];
}

- (void)refreshData {
    [self.data removeAllObjects];
    NSDictionary *monitorDictionary = [WXAMonitorHandler sharedInstance].monitorDictionary;
    if (monitorDictionary) {
        for (NSString *instanceId in monitorDictionary) {
            WXAPerformanceData *data = [WXAPerformanceData new];
            NSMutableArray *models = [NSMutableArray new];
            NSDictionary *dictionary= monitorDictionary[instanceId];
            for (NSString *key in dictionary) {
                [models addObject:[self modelForTitle:key value:dictionary[key] category:WXAPerformanceCategoryBasic]];
            }
            data.models = models;
            data.instanceId = instanceId;
            data.bundleUrl = dictionary[@"url"];
            [self.data addObject:data];
        }
        [self.data sortUsingComparator:^NSComparisonResult(WXAPerformanceData*  _Nonnull obj1, WXAPerformanceData*  _Nonnull obj2) {
            return [obj1.instanceId integerValue] < [obj2.instanceId integerValue];
        }];
    }
    [self.tableView reloadData];
}

- (WXAPerformanceModel *)modelForTitle:(NSString *)title
                                 value:(NSString *)value
                              category:(WXAPerformanceCategory)category {
    return [[WXAPerformanceModel alloc] initWithTitle:title value:value category:category];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WXAPerformanceData *data = self.data[section];
    return data.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 58;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WXAPerformanceData *data = self.data[section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    label.text = [NSString stringWithFormat:@"instanceId: %@", data.instanceId];
    [view addSubview:label];
    
    if (data) {
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, tableView.frame.size.width, 30)];
        [subLabel setFont:[UIFont systemFontOfSize:12]];
        subLabel.lineBreakMode = NSLineBreakByWordWrapping;
        subLabel.numberOfLines = 0;
        NSString *subString = [NSString stringWithFormat:@"bundleUrl:%@", data.bundleUrl];
        /* Section header is in 0th index... */
        [subLabel setText:subString];
        [view addSubview:subLabel];
    }
    
    [view setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1]];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXAPerformanceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    WXAPerformanceData *data = self.data[indexPath.section];
    cell.model = data.models[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.data.count) {
        WXAPerformanceData *data = self.data[indexPath.section];
        if (indexPath.row < data.models.count) {
            WXAPerformanceModel *model = data.models[indexPath.row];
            return [WXAPerformanceCell estimateCellHeight:model containerWidth:self.tableView.frame.size.width];
        }
    }
    return 60;
}

@end
