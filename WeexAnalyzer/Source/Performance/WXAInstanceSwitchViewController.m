//
//  WXAInstanceSwitchViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/28.
//

#import "WXAInstanceSwitchViewController.h"
#import "WXAMonitorDataManager.h"

@interface WXAInstanceSwitchViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WXAInstanceSwitchViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.blackColor;
    [self.tableView registerClass:WXAInstanceTableViewCell.class forCellReuseIdentifier:@"cellIdentifier"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:self.tableView];
    
    _data = WXAMonitorDataManager.sharedInstance.allInstance;
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(newInstanceCome:)
                                               name:kWXAMonitorNewInstanceNotification
                                             object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)newInstanceCome:(NSNotification *)notification {
    _data = WXAMonitorDataManager.sharedInstance.allInstance;
    [_tableView reloadData];
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
    WXAInstanceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"
                                                                     forIndexPath:indexPath];
    if (_data.count > indexPath.row) {
        NSDictionary *data =  _data[indexPath.row];
        cell.urlLabel.text = [data objectForKey:@"wxBundleUrl"];
        cell.instanceLabel.text = [NSString stringWithFormat:@"instanceId: %@",
                                   [data objectForKey:@"instanceId"]];
        cell.timeLabel.text = [data objectForKey:@"dateline"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_data.count > indexPath.row) {
        NSDictionary *data =  _data[indexPath.row];
        [NSNotificationCenter.defaultCenter postNotificationName:kWXAMonitorSelectNotification object:data];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

@implementation WXAInstanceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = nil;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        _urlLabel = [UILabel new];
        _urlLabel.font = [UIFont systemFontOfSize:12];
        _urlLabel.textColor = UIColor.whiteColor;
        _urlLabel.textAlignment = NSTextAlignmentLeft;
        _urlLabel.numberOfLines = 0;
        [self.contentView addSubview:_urlLabel];
        
        _instanceLabel = [UILabel new];
        _instanceLabel.font = [UIFont systemFontOfSize:12];
        _instanceLabel.textColor = UIColor.lightGrayColor;
        _instanceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_instanceLabel];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = UIColor.lightGrayColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _urlLabel.frame = CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height - 20);
    _instanceLabel.frame = CGRectMake(10, 30, self.bounds.size.width/2.0, 20);
    _timeLabel.frame = CGRectMake(0, 30, self.bounds.size.width-10, 20);
    
}

@end
