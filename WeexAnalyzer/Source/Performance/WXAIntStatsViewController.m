//
//  WXAIntStatsViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import "WXAIntStatsViewController.h"
#import "WXAMonitorDataManager.h"
#import "WXAIntTableViewCell.h"

@interface WXAIntStatsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSDictionary *monitor;

@end

@implementation WXAIntStatsViewController

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
    return @"stats";
}

- (void)load {
    _monitor = [WXAMonitorDataManager.sharedInstance.monitorDictionary[self.instanceId] objectForKey:@"stats"];
    NSMutableArray *data = [NSMutableArray new];
//    if (_monitor) {
        NSDictionary *map = @{
                              //老点
                              @"wxBundleSize":@"加载bundle的大小",
                              @"wxEmbedCount":@"embed个数",
                              @"wxFSCallJsTotalTime":@"首屏时间调用js耗时",
                              @"wxFSCallJsTotalNum":@"首屏时间调用js次数",
                              @"wxFSCallNativeTotalTime":@"首屏时间调用native时间",
                              @"wxFSCallNativeTotalNum":@"首屏时间调用native次数",
                              @"wxFSCallEventTotalNum":@"首屏时间event次数",
                              @"wxFSRequestNum":@"首屏时间网络请求次数",
                              @"wxCellExceedNum":@"大cell个数",
                              @"wxMaxDeepViewLayer":@"view最大层级",
                              @"wxMaxDeepVDomLayer":@"dom结点最大层级",
                              @"wxMaxComponentCount":@"组件个数（最多那次）",
                              @"wxInteractionTime":@"可交互渲染时间",
                              @"wxWrongImgSizeCount":@"图片和view大小不匹配个数",
                              @"wxFSTimerCount":@"首屏调用timer次数",
                              @"wxActualNetworkTime":@"网络库打点的bundle下载时间",
                              
                              //WEEX新点
                              @"wxScrollerCount":@"使用scroller个数",
                              @"wxCellDataUnRecycleCount":@"内容不回收的cell组件个数",
                              @"wxCellUnReUseCount":@"没有开启复用cell的个数",
                              @"wxImgUnRecycleCount":@"未开启图片自动回收imgview的个数",
                              @"wxLargeImgMaxCount":@"大图个数（最多那次）",
                              @"wxInteractionScreenViewCount":@"可交互时间内，屏幕(instance)内addview次数",
                              @"wxInteractionAllViewCount":@"可交互时间内，屏幕((instance))内外总共add view的次数",
                              @"wxInteractionComponentCreateCount":@"可交互时间内，创建component个数",
                              @"wxAnimationInBackCount":@"后台执行动画次数",
                              @"wxTimerInBackCount":@"后台执行timer次数",
                              @"wxImgLoadCount":@"图片加载个数",
                              @"wxImgLoadSuccessCount":@"图片加载成功个数",
                              @"wxImgLoadFailCount":@"图片加载失败个数",
                              @"wxNetworkRequestCount":@"网络请求次数",
                              @"wxNetworkRequestSuccessCount":@"网络请求成功次数",
                              @"wxNetworkRequestFailCount":@"网络请求失败次数",
                              @"wxMtopTime":@"前端mtop请求时间",
                              @"wxJSDataPrefetchTime":@"前端prefetch请求时间",
                              @"wxJSDataPrefetchSuccess":@"前端prefetch是否成功",
                              @"wxViewDeepForRoot":@"相对于屏幕上根结点的最大view深度",
                              
//                              //apm提供点
//                              @"fps":@"进出平均fps",
//                              @"memDiff":@"进入退出内存变化",
//                              @"imgLoadCount":@"图片加载个数",
//                              @"imgLoadSuccessCount":@"图片加载成功个数",
//                              @"imgLoadFailCount":@"图片加载失败个数",
//                              @"networkRequestCount":@"网络请求次数",
//                              @"networkRequestSuccessCount":@"网络请求成功次数",
//                              @"networkRequestFailCount":@"网络请求失败次数",
                              };
        
        for (NSString *key in map.allKeys) {
            NSString *name = [map objectForKey:key];
            NSString *value = [NSString stringWithFormat:@"%@", [_monitor objectForKey:key]];
            if (name) {
                [data addObject:@{
                                  @"key":name,
                                  @"value":value,
                                  }];
            }
        }
//    }
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
    return 40;
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
