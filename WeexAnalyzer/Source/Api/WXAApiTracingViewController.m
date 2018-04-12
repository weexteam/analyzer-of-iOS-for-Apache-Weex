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
#import "WXTracingMethodViewController.h"

@interface WXAApiTracingViewController ()

@property (strong,nonatomic) NSArray     *content;
@property (strong,nonatomic) NSMutableArray *apis;
@property (nonatomic) NSTimeInterval begin;
@property (nonatomic) NSTimeInterval end;

@end

@implementation WXAApiTracingViewController

- (void)viewDidLoad {
    self.title= @"API";
    [super viewDidLoad];
    
    NSDictionary *dict = [WXTracingManager getTacingApi];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.apis count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXATracingApiTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if(cell == nil) {
        cell = [[WXATracingApiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
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
        WXTracingMethodViewController *methodViewController = [[WXTracingMethodViewController alloc] init];
        methodViewController.methods = [dict objectForKey:@"methods"];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:methodViewController animated:YES];
    }
}

@end
