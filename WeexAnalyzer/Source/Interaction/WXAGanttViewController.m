//
//  WXAGanttViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/26.
//

#import "WXAGanttViewController.h"
#import "WXAGanttView.h"
#import "WXAMonitorHandler.h"
#import "WXAGanttData.h"

@interface WXAGanttViewController ()

@property(nonatomic, strong) WXAGanttView *ganttView;

@end

@implementation WXAGanttViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ganttView = [[WXAGanttView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_ganttView];
    [self loadData];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(monitor:)
                                               name:kWXAMonitorHandlerNotification
                                             object:nil];
    
}

- (void)loadData {
    WXAGanttData *ganttData = [WXAGanttData dataWithMonitor:WXAMonitorHandler.sharedInstance.monitorDictionary[@"0"]];
    _ganttView.axisMaxY = ganttData.interaction.end;
    _ganttView.secondOpenTime = ganttData.secondOpenTime;
    _ganttView.datas = @[
                         ganttData.downloadBundle,
                         ganttData.handleBundle,
                         ganttData.firstIneractionView,
                         ganttData.async,
                         ganttData.interaction,
                         ];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _ganttView.frame = self.view.bounds;
    [_ganttView setNeedsDisplay];
}

- (void)monitor:(NSNotification *)notifiction {
    if ([notifiction.object isKindOfClass:NSString.class]) {
        if ([notifiction.object isEqualToString:@"stage"]) {
            [self loadData];
            [_ganttView setNeedsDisplay];
        }
    }
}

@end
