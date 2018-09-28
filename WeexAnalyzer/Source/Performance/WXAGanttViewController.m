//
//  WXAGanttViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/26.
//

#import "WXAGanttViewController.h"
#import "WXAGanttView.h"
#import "WXAMonitorDataManager.h"
#import "WXAGanttData.h"

@interface WXAGanttViewController ()

@property(nonatomic, strong) WXAGanttView *ganttView;
@property(nonatomic, strong) WXAGanttData *ganttData;

@end

@implementation WXAGanttViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ganttView = [[WXAGanttView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_ganttView];
    self.contentView = _ganttView;
    [self fresh];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_ganttView setNeedsDisplay];
}

- (void)load {
    _ganttData = [WXAGanttData dataWithMonitor:WXAMonitorDataManager.sharedInstance.monitorDictionary[self.instanceId]];
}

- (void)fresh {
    _ganttView.axisMaxY = _ganttData.interaction.end;
    _ganttView.secondOpenTime = _ganttData.secondOpenTime;
    _ganttView.datas = @[
                         _ganttData.downloadBundle,
                         _ganttData.handleBundle,
                         _ganttData.firstIneractionView,
                         _ganttData.async,
                         _ganttData.interaction,
                         ];
}

- (void)reload {
    [self load];
    [self fresh];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_ganttView setNeedsDisplay];
    });
}

- (NSString *)type {
    return @"stage";
}

@end
