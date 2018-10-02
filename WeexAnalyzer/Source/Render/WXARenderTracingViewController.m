//
//  WXRenderTracingViewController.m
//  TBWXDevTool
//
//  Created by 齐山 on 2017/7/4.
//  Copyright © 2017年 Taobao. All rights reserved.
//

#import "WXARenderTracingViewController.h"
#import <UIKit/UIKit.h>
#import <WeexSDK/WeexSDK.h>
#import "WXARenderTracingTableViewCell.h"
#import "WXSubRenderTracingTableViewCell.h"
@implementation WXAShowTracingTask
@end

@implementation WXAShowTracing
@end

@interface WXARenderTracingViewController ()

@property (strong,nonatomic) NSArray     *content;
@property (strong,nonatomic) NSMutableArray *tasks;
@property (nonatomic) NSTimeInterval begin;
@property (nonatomic) NSTimeInterval end;
@property (nonatomic,copy) NSString *sectionTitle;
@property (assign, nonatomic) BOOL isExpand; //是否展开
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;//展开的cell的下标

@end

@implementation WXARenderTracingViewController

- (instancetype)initWithFrame:(CGRect )frame
{
    if ((self = [super init])) {
        self.view.frame = frame;
    }
    return self;
}
    
   
- (void)viewDidLoad {
    self.title= @"Render性能";
    [super viewDidLoad];
    
    [self cofigureTableview];
    
    
    [self refreshData];
    
}

-(void)refreshNewData
{
    self.tasks = [NSMutableArray new];
    NSMutableDictionary *taskData = [[WXTracingManager getTracingData] mutableCopy];
    NSArray *instanceIds = [[WXSDKManager bridgeMgr] getInstanceIdStack];
    if(instanceIds && [instanceIds count] >0){
        for (NSInteger i = 0; i< [instanceIds count]; i++) {
            NSString *instanceId =instanceIds[i];
            WXTracingTask *task = [taskData objectForKey:instanceId];
            //            NSString *str = [WXUtility JSONString:[self formatTask:task]];
            WXAShowTracingTask *showTask = [WXAShowTracingTask new];
            showTask.counter = task.counter;
            showTask.iid = task.iid;
            showTask.tag = task.tag;
            showTask.bundleUrl = task.bundleUrl;
            showTask.bundleJSType = task.bundleJSType;
            NSMutableArray *tracings = [NSMutableArray new];
            for (WXTracing *tracing in task.tracings) {
                if(![WXTracingEnd isEqualToString:tracing.ph]){
                    [tracings addObject:tracing];
                    if(showTask.begin <0.0001){
                        showTask.begin = tracing.ts;
                    }
                    
                    if(tracing.ts < showTask.begin){
                        showTask.begin = tracing.ts;
                    }
                    if((tracing.ts +tracing.duration) > showTask.end){
                        showTask.end = tracing.ts +tracing.duration ;
                    }
                }
            }
            showTask.tracings = [NSMutableArray new];
            showTask.tracings = tracings;
            [self.tasks addObject:showTask];
        }
    }
    if(!self.tasks || [self.tasks count] == 0)
    {
        WXAShowTracingTask *showTask = [WXAShowTracingTask new];
        showTask.tracings = [NSMutableArray new];
        self.tasks = [NSMutableArray new];
        [self.tasks addObject:showTask];
    }
    [self.tableView reloadData];
}

-(WXAShowTracing *)getShowTracing:(WXTracing *)tracing tracings:(NSMutableArray *)tracings
{
    for (WXAShowTracing *t in tracings) {
        if(t.traceId ==  tracing.parentId){
            return t;
        }
    }
    return nil;
}

- (WXAShowTracing *)copyTracing:(WXTracing *)tracing
{
    WXAShowTracing *newTracing = [WXAShowTracing new];
    if(tracing.ref.length>0){
        newTracing.ref = tracing.ref;
    }
    if(tracing.parentRef.length>0){
        newTracing.parentRef = tracing.parentRef;
    }
    if(tracing.className.length>0){
        newTracing.className = tracing.className;
    }
    if(tracing.name.length>0){
        newTracing.name = tracing.name;
    }
    if(tracing.fName.length>0){
        newTracing.fName = tracing.fName;
    }
    if(tracing.ph.length>0){
        newTracing.ph = tracing.ph;
    }
    if(tracing.iid.length>0){
        newTracing.iid = tracing.iid;
    }
    newTracing.parentId = tracing.parentId;
    if(tracing.traceId>0){
        newTracing.traceId = tracing.traceId;
    }
    if(tracing.ts>0){
        newTracing.ts = tracing.ts;
    }
    if(tracing.threadName.length>0){
        newTracing.threadName = tracing.threadName;
    }
    return newTracing;
}


-(void)refreshData
{
    self.tasks = [NSMutableArray new];
    NSMutableDictionary *taskData = [[WXTracingManager getTracingData] mutableCopy];
    NSArray *instanceIds = [[WXSDKManager bridgeMgr] getInstanceIdStack];
//    BOOL isRenderFinish = [WXDebugger renderFinishEnabled];
    BOOL isRenderFinish = YES;
    if(instanceIds && [instanceIds count] >0){
        for (NSInteger i = 0; i< [instanceIds count]; i++) {
            NSString *instanceId =instanceIds[i];
            WXTracingTask *task = [taskData objectForKey:instanceId];
            //            NSString *str = [WXUtility JSONString:[self formatTask:task]];
            WXAShowTracingTask *showTask = [WXAShowTracingTask new];
            showTask.counter = task.counter;
            showTask.iid = task.iid;
            showTask.tag = task.tag;
            showTask.bundleUrl = task.bundleUrl;
            showTask.bundleJSType = task.bundleJSType;
            NSMutableArray *tracings = [NSMutableArray new];
            for (WXTracing *tracing in task.tracings) {
                if(![WXTracingEnd isEqualToString:tracing.ph]){
                    WXAShowTracing *showTracing = [self getShowTracing:tracing tracings:tracings];
                    if(showTask.begin <0.0001){
                        showTask.begin = tracing.ts;
                    }
                    
                    if(tracing.ts < showTask.begin){
                        showTask.begin = tracing.ts;
                    }
                    if((tracing.ts +tracing.duration) > showTask.end){
                        showTask.end = tracing.ts +tracing.duration ;
                    }
                    
                    if(!showTracing){
                        showTracing = [self copyTracing:tracing];
                        showTracing.subTracings = [NSMutableArray new];
                        [tracings addObject:showTracing];
                        if((tracing.ts +tracing.duration) > showTracing.ts+showTracing.duration){
                            showTracing.duration =  tracing.ts +tracing.duration - showTracing.ts;
                        }
                        [showTracing.subTracings addObject:tracing];
                    }else{
                        if((tracing.ts +tracing.duration) > showTracing.ts+showTracing.duration){
                            showTracing.duration =  tracing.ts +tracing.duration - showTracing.ts;
                        }
                        [showTracing.subTracings addObject:tracing];
                    }
                }
                if(isRenderFinish){
                    if([@"renderFinish" isEqualToString:tracing.fName] && [WXTracingInstant isEqualToString:tracing.ph] && [WXTUIThread isEqualToString:tracing.threadName])
                    {
                        break;
                    }
                }
            }
            for(WXAShowTracing *tracing in tracings){
                if([tracing.subTracings count] == 1){
                    tracing.subTracings = [NSMutableArray new];
                }
            }
            showTask.tracings = [NSMutableArray new];
            showTask.tracings = tracings;
            [self.tasks addObject:showTask];
        }
    }
    if(!self.tasks || [self.tasks count] == 0)
    {
        WXAShowTracingTask *showTask = [WXAShowTracingTask new];
        showTask.tracings = [NSMutableArray new];
        self.tasks = [NSMutableArray new];
        [self.tasks addObject:showTask];
    }
    [self.tableView reloadData];
}

-(void)cofigureTableview
{
    [self.tableView registerClass:[WXARenderTracingTableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    [self.tableView registerClass:[WXSubRenderTracingTableViewCell class] forCellReuseIdentifier:@"subcellIdentifier"];
    [self.contentView addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tasks count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WXAShowTracingTask *task = self.tasks[section];
    NSInteger count = [task.tracings count];
    if(self.selectedIndexPath && self.selectedIndexPath.section == section){
        if (self.isExpand) {
            count = count + [self getSubTracingCount:self.selectedIndexPath];
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    WXAShowTracingTask *task = self.tasks[indexPath.section];
    //    [cell config:[task.tracings objectAtIndex:indexPath.row] begin:task.begin end:task.end];
    
    if(self.isExpand) {
        if(indexPath.section == self.selectedIndexPath.section){
            if(self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + [self getSubTracingCount:self.selectedIndexPath]){
                WXAShowTracing *showTracing = [task.tracings objectAtIndex:self.selectedIndexPath.row];
                WXTracing *tracing = [showTracing.subTracings objectAtIndex:(indexPath.row - self.selectedIndexPath.row-1)];
                WXSubRenderTracingTableViewCell *subCell = [tableView dequeueReusableCellWithIdentifier:@"subcellIdentifier" forIndexPath:indexPath];
                [subCell config:tracing begin:task.begin end:task.end];
                cell = subCell;
            }else if(indexPath.row > self.selectedIndexPath.row + [self getSubTracingCount:self.selectedIndexPath]){
                WXARenderTracingTableViewCell *showCell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
                [showCell config:[task.tracings objectAtIndex:indexPath.row - [self getSubTracingCount:self.selectedIndexPath]] begin:task.begin end:task.end];
                cell = showCell;
            }else{
                WXARenderTracingTableViewCell *showCell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
                [showCell config:[task.tracings objectAtIndex:indexPath.row] begin:task.begin end:task.end];
                cell = showCell;
                
            }
            
            
        }else{
            WXARenderTracingTableViewCell *showCell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
            [showCell config:[task.tracings objectAtIndex:indexPath.row] begin:task.begin end:task.end];
            cell = showCell;
        }
        
    }else {
        WXARenderTracingTableViewCell *showCell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        [showCell config:[task.tracings objectAtIndex:indexPath.row] begin:task.begin end:task.end];
        cell = showCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"title of cell %@", [_content objectAtIndex:indexPath.row]);
    NSInteger count = [self getSubTracingCount:self.selectedIndexPath];
    if(count == 0){
        self.selectedIndexPath = nil;
    }
    
    if (!self.selectedIndexPath) {
        self.isExpand = YES;
        self.selectedIndexPath = indexPath;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsForExpand:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    } else {
        if (self.isExpand) {
            NSArray *tracings = [self  indexPathsForExpand:indexPath];
            if (self.selectedIndexPath == indexPath) {
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:tracings withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
            } else if (self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + [tracings count]) {
                
            } else {
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpand:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
            }
        }
    }
}

-(NSInteger)getSubTracingCount:(NSIndexPath *)selectedIndexPath
{
    WXAShowTracingTask *task = [self.tasks objectAtIndex:selectedIndexPath.section];
    WXAShowTracing *tracing = [task.tracings objectAtIndex:selectedIndexPath.row];
    return [tracing.subTracings count];
}

- (NSArray *)indexPathsForExpand:(NSIndexPath *)selectedIndexPath {
    WXAShowTracingTask *task = [self.tasks objectAtIndex:selectedIndexPath.section];
    WXAShowTracing *tracing = [task.tracings objectAtIndex:selectedIndexPath.row];
    //    return @[tracing];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 1; i <= [tracing.subTracings count]; i++) {
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:selectedIndexPath.row + i inSection:selectedIndexPath.section];
        [indexPaths addObject:idxPth];
    }
    return [indexPaths copy];
}

#pragma mark -
#pragma section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 58;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WXTracingTask *task = [self.tasks objectAtIndex:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    label.textColor = UIColor.whiteColor;
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    NSString *string = [NSString stringWithFormat:@"instanceId:%@",task.iid];
    if(!task.iid){
        string = @"没有打开Tracking或暂时没有weex页面渲染";
    }
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    if(!task.iid){
        return view;
    }
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, tableView.frame.size.width, 30)];
    [subLabel setFont:[UIFont systemFontOfSize:12]];
    subLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subLabel.numberOfLines = 0;
    NSString *subString = [NSString stringWithFormat:@"bundleUrl:%@",task.bundleUrl];
    /* Section header is in 0th index... */
    [subLabel setText:subString];
    [view addSubview:subLabel];
    
    [view setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1]];
    return view;
}

@end
