//
//  WXANetworkTracingViewController.m
//  WeexAnalyzerBundle
//
//  Created by 对象 on 2018/3/21.
//

#import "WXANetworkTracingViewController.h"
#import "WXNetworkRecorder.h"
#import "WXANetworkCell.h"
#import "WXNetworkTransactionDetailTableViewController.h"

@interface WXANetworkTracingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *table;
@property (nonatomic, copy) NSArray<WXNetworkTransaction *> *networkTransactions;
@property (strong,nonatomic) NSArray     *content;
@property (strong,nonatomic) NSMutableArray *apis;
@property (nonatomic) NSTimeInterval begin;
@property (nonatomic) NSTimeInterval end;

@end

@implementation WXANetworkTracingViewController


- (void)viewDidLoad {
    
    self.title= @"网络";
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateTransactions:) name:kWXNetworkRecorderTransactionUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactions:) name:kWXNetworkRecorderNewTransactionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactions:) name:kWXNetworkRecorderTransactionUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactions:) name:kWXNetworkRecorderTransactionsClearedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactions:) name:kWXNetworkObserverEnabledStateChangedNotification object:nil];
    
    [self updateTransactions:nil];
}

- (void)updateTransactions:(NSNotification *)notification {
    self.networkTransactions = [[WXNetworkRecorder defaultRecorder] networkTransactions];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.networkTransactions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    WXANetworkCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[WXANetworkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSInteger row = [indexPath row];
    if (self.networkTransactions.count > row) {
        cell.transaction = self.networkTransactions[row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WXANetworkCell preferredCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WXNetworkTransactionDetailTableViewController *detailViewController = [[WXNetworkTransactionDetailTableViewController alloc] init];
    detailViewController.transaction = [self transactionAtIndexPath:indexPath inTableView:tableView];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (WXNetworkTransaction *)transactionAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    return self.networkTransactions[indexPath.row];
}


@end

