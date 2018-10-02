//
//  WXASettingViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/10/2.
//

#import "WXASettingViewController.h"
#import <WeexSDK/WeexSDK.h>

@interface WXASettingViewController ()

@end

@interface WXASettingSwitchCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UISwitch *uiswitch;

@end

@implementation WXASettingViewController

- (void)viewDidLoad {
    self.title= @"设置";
    [super viewDidLoad];
    
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
    WXASettingSwitchCell *cell = (WXASettingSwitchCell *)[self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if(cell == nil) {
        cell = [[WXASettingSwitchCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellIdentifier"];
        
        cell.label.text = @"打开Tracking";
        [cell.uiswitch setOn:[NSUserDefaults.standardUserDefaults boolForKey:@"WXA_OPEN_Tracing"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


@end

@implementation WXASettingSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = UIColor.whiteColor;
        [self.contentView addSubview:_label];
        
        //UISwitch默认大小是51*31
        _uiswitch = [UISwitch new];
        [_uiswitch addTarget:self action:@selector(switchHandler:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_uiswitch];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _label.frame = CGRectMake(10, 0, 200, self.bounds.size.height);
    _uiswitch.frame = CGRectMake(self.contentView.bounds.size.width-61, (self.bounds.size.height-31)/2, 51, 31);
    
}

- (void)switchHandler:(UISwitch *)switcher {
    [WXTracingManager switchTracing:switcher.on];
    [NSUserDefaults.standardUserDefaults setBool:switcher.on forKey:@"WXA_OPEN_Tracing"];
}

@end
