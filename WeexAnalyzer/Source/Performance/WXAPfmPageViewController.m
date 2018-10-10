//
//  WXAPfmPageViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/13.
//

#import "WXAPfmPageViewController.h"
#import "WXAGanttViewController.h"
#import "WXAIntBaseInfoViewController.h"
#import "WXAIntStatsViewController.h"
#import "WXAIntViewController.h"
#import "WXAPageTabbar.h"
#import "WXAUtility.h"
#import "WXAInstanceSwitchViewController.h"
#import "WXAMonitorDataManager.h"

@interface WXAPfmPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *clazzes;
@property (nonatomic, strong) WXAPageTabbar *tabbar;
@property (nonatomic, assign) NSInteger peddingIndex;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) WXAInstanceSwitchViewController *switchController;
@property (nonatomic, strong) UILabel *selectedUrlLabel;
@property (nonatomic, strong) UIButton *instanceChoose;
@property (nonatomic, strong) NSString *selectedInstanceId;

@end

@implementation WXAPfmPageViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    self.title = @"可交互性能分析";
    self.minContentHeight = 460;
    [super viewDidLoad];
    
    _selectedInstanceId = WXAMonitorDataManager.sharedInstance.latestInstanceId;
    
    _clazzes = @[
                 WXAIntBaseInfoViewController.class,
                 WXAGanttViewController.class,
                 WXAIntStatsViewController.class,
                 WXAIntViewController.class,
                 ];
    
    //分页
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    WXAGanttViewController *ganttViewController = [WXAGanttViewController new];
    ganttViewController.instanceId = self.selectedInstanceId;
    [_pageViewController setViewControllers:@[ganttViewController]
                                 direction:UIPageViewControllerNavigationDirectionReverse
                                  animated:NO
                                completion:nil];
    [self addChildViewController:_pageViewController];
    [self.contentView addSubview:_pageViewController.view];
    
    
    //tabbar
    _tabbar = [[WXAPageTabbar alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height-50, self.contentView.bounds.size.width, 50) tabs:@[@"概览", @"核心指标", @"计数埋点", @"渲染耗时"]];
    [self.contentView addSubview:_tabbar];
    [_tabbar setCurrent:1];__weak typeof(self) weakSelf = self;
    _tabbar.select = ^(NSInteger current, NSInteger last) {
        UIPageViewControllerNavigationDirection direction = current < last ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
        WXAPfmIntBaseViewController *controller = [[weakSelf.clazzes objectAtIndex:current] new];
        controller.instanceId = weakSelf.selectedInstanceId;
        [weakSelf.pageViewController setViewControllers:@[controller]
                                              direction: direction
                                               animated:YES
                                             completion:nil];
    };
    
    
    [self createSwitch];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(instanceChanged:)
                                               name:kWXAMonitorSelectNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(newInstanceCome:)
                                               name:kWXAMonitorNewInstanceNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(wxBundleUrlCome:)
                                               name:kWXAMonitorWXBundleUrlNotification
                                             object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tabbar.frame = CGRectMake(0, self.contentView.bounds.size.height-50, self.contentView.bounds.size.width, 50);
    _pageViewController.view.frame = CGRectMake(0, 50, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 100);
    _switchController.view.frame = CGRectMake(0, 50, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 50);
}



- (void)createSwitch {
    //顶部instance选择
    CGFloat width = self.contentView.bounds.size.width;
    UIButton *instanceChoose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    [instanceChoose setBackgroundColor:UIColor.clearColor];
    [instanceChoose addTarget:self action:@selector(switchInstance:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:instanceChoose];
    _instanceChoose = instanceChoose;
    
    UILabel *urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - 50, 50)];
    urlLabel.text = WXAMonitorDataManager.sharedInstance.latestInstance[@"wxBundleUrl"];
    urlLabel.font = [UIFont systemFontOfSize:12];
    urlLabel.numberOfLines = 2;
    urlLabel.textColor = UIColor.whiteColor;
    [instanceChoose addSubview:urlLabel];
    _selectedUrlLabel = urlLabel;
    
    UILabel *tag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width-10, 50)];
    tag.text = @"▼";
    tag.font = [UIFont systemFontOfSize:15];
    tag.textColor = UIColor.whiteColor;
    tag.textAlignment = NSTextAlignmentRight;
    [instanceChoose addSubview:tag];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50-1, width, 1/UIScreen.mainScreen.scale)];
    line.backgroundColor = UIColor.lightGrayColor;
    [instanceChoose addSubview:line];
    
    
    //instance切换
    _switchController = [WXAInstanceSwitchViewController new];
    [self addChildViewController:_switchController];
    [self.contentView addSubview:_switchController.view];
    _switchController.view.hidden = YES;
}

- (void)switchInstance:(UIButton *)button {
    button.selected = !button.isSelected;
    _switchController.view.hidden = !button.isSelected;
}

- (void)instanceChanged:(NSNotification *)notification {
    _instanceChoose.selected = NO;
    _switchController.view.hidden = YES;
    NSString *instanceId = [notification.object objectForKey:@"instanceId"];
    NSString *wxBundleUrl = [notification.object objectForKey:@"wxBundleUrl"];
    _selectedUrlLabel.text = [NSString stringWithFormat:@"%@:%@", instanceId, wxBundleUrl];
    _selectedInstanceId = instanceId;
}

- (void)newInstanceCome:(NSNotification *)notification {
    _selectedUrlLabel.text = notification.object;
    _selectedInstanceId = notification.object;
    [NSNotificationCenter.defaultCenter postNotificationName:kWXAMonitorSelectNotification
                                                      object:@{
                                                               @"instanceId" : notification.object
                                                               }];
}

- (void)wxBundleUrlCome:(NSNotification *)notification {
    NSDictionary *data = notification.object;
    NSString *instanceId = [data objectForKey:@"instanceId"];
    NSString *wxBundleUrl = [notification.object objectForKey:@"wxBundleUrl"];
    if (instanceId && [instanceId isEqualToString:_selectedInstanceId]) {
        _selectedUrlLabel.text = [NSString stringWithFormat:@"%@:%@", instanceId, wxBundleUrl];
    }
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    NSInteger index = [_clazzes indexOfObject:viewController.class];
    index--;
    if (index < 0) {
        index = _clazzes.count - 1;
    }
    WXAPfmIntBaseViewController *controller = [[_clazzes objectAtIndex:index] new];
    controller.instanceId = _selectedInstanceId;
    return controller;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [_clazzes indexOfObject:viewController.class];
    index++;
    if (index >= _clazzes.count) {
        index = 0;
    }
    WXAPfmIntBaseViewController *controller = [[_clazzes objectAtIndex:index] new];
    controller.instanceId = _selectedInstanceId;
    return controller;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    _peddingIndex = [_clazzes indexOfObject: pendingViewControllers.firstObject.class];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        [_tabbar setCurrent:_peddingIndex];
    }
}

@end
