//
//  WXABaseTableViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/4/11.
//

#import "WXABaseTableViewController.h"

@interface WXABaseTableViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation WXABaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = nil;
    [self.contentView addSubview:self.tableView];
}

- (void)windowResize:(CGSize)size {
    self.tableView.frame = self.contentView.bounds;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
