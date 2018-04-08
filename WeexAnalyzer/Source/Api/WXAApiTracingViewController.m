//
//  WXRenderTracingViewController.m
//  TBWXDevTool
//
//  Created by 齐山 on 2017/7/4.
//  Copyright © 2017年 Taobao. All rights reserved.
//

#import "WXAApiTracingViewController.h"
#import <UIKit/UIKit.h>
#import "WXARenderTracingTableViewCell.h"
#import "WXATracingApiTableViewCell.h"

@interface WXAApiTracingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *table;
@property (strong,nonatomic) NSArray     *content;
@property (strong,nonatomic) NSMutableArray *apis;
@property (nonatomic) NSTimeInterval begin;
@property (nonatomic) NSTimeInterval end;

@end

@implementation WXAApiTracingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.titleLabel.text = @"API";
    
    NSDictionary *dict = [WXTracingManager getTacingApi];
    [self cofigureTableview];
    self.apis = [NSMutableArray new];
    if([dict objectForKey:@"module"]){
        for (NSDictionary *d in [dict objectForKey:@"module"]) {
            [self.apis addObject:d];
        }
    }
    if([dict objectForKey:@"componet"]){
        for (NSDictionary *d in [dict objectForKey:@"componet"]) {
            [self.apis addObject:d];
        }
    }
    if([dict objectForKey:@"module"]){
        for (NSDictionary *d in [dict objectForKey:@"handle"]) {
            [self.apis addObject:d];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)cofigureTableview
{
    self.table = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.contentView addSubview:self.table];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.apis count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    WXATracingApiTableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellIdentifier];

    if(cell == nil) {
        cell = [[WXATracingApiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSInteger row = [indexPath row];
    [cell config:self.apis[row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.apis[indexPath.row];
    if([dict objectForKey:@"methods"]){
//        WXTracingMethodViewController *methodViewController = [[WXTracingMethodViewController alloc] init];
//        methodViewController.methods = [dict objectForKey:@"methods"];
//        [self.navigationController setNavigationBarHidden:NO];
//        [self.navigationController pushViewController:methodViewController animated:YES];
    }
}

@end
