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
#import "WXAPfmTabbar.h"
#import "WXAUtility.h"

@interface WXAPfmPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *clazzes;
@property (nonatomic, strong) WXAPfmTabbar *tabbar;
@property (nonatomic, assign) NSInteger peddingIndex;

@end

@implementation WXAPfmPageViewController

- (void)viewDidLoad {
    self.title = @"可交互性能分析";
    self.minContentHeight = 325;
    
    [super viewDidLoad];
    
    _tabbar = [[WXAPfmTabbar alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, 50)];
    [self.contentView addSubview:_tabbar];
    [_tabbar setCurrent:1];
    
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    [pageViewController setViewControllers:@[[WXAGanttViewController new]]
                                 direction:UIPageViewControllerNavigationDirectionReverse
                                  animated:NO
                                completion:nil];
    pageViewController.view.frame = CGRectMake(0, 50, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 50);
    [self addChildViewController:pageViewController];
    [self.contentView addSubview:pageViewController.view];
    
    _clazzes = @[
                 WXAIntBaseInfoViewController.class,
                 WXAGanttViewController.class,
                 WXAIntStatsViewController.class,
                 WXAIntViewController.class,
                 ];
    
    __weak typeof(pageViewController) weakPageVC = pageViewController;
    __weak typeof(self) weakSelf = self;
    _tabbar.select = ^(NSInteger select) {
        [weakPageVC setViewControllers:@[[[weakSelf.clazzes objectAtIndex:select] new]]
                                     direction:UIPageViewControllerNavigationDirectionReverse
                                      animated:YES
                                    completion:nil];
    };
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    NSInteger index = [_clazzes indexOfObject:viewController.class];
    index--;
    if (index < 0) {
        index = _clazzes.count - 1;
    }
    return [[_clazzes objectAtIndex:index] new];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [_clazzes indexOfObject:viewController.class];
    index++;
    if (index >= _clazzes.count) {
        index = 0;
    }
    return [[_clazzes objectAtIndex:index] new];
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
