//
//  WXAInteractionViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/13.
//

#import "WXAInteractionViewController.h"
#import "WXAGanttViewController.h"

@interface WXAInteractionViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation WXAInteractionViewController

- (void)viewDidLoad {
    self.title = @"可交互性能分析";
    self.minContentHeight = 325;
    
    [super viewDidLoad];
    
    
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    
    [pageViewController setViewControllers:@[[WXAGanttViewController new]]
                                 direction:UIPageViewControllerNavigationDirectionReverse
                                  animated:NO
                                completion:nil];
    
    pageViewController.view.frame = self.contentView.bounds;
    [self addChildViewController:pageViewController];
    [self.contentView addSubview:pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
//    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
//    if ((index == 0) || (index == NSNotFound)) {
//        return nil;
//    }
//    index--;
//    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
//    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
//    // 不用我们去操心每个ViewController的顺序问题
//    return [self viewControllerAtIndex:index];
    return [WXAGanttViewController new];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    return [WXAGanttViewController new];
}

//#pragma mark - 根据index得到对应的UIViewController
//
//- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index {
//    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
//        return nil;
//    }
//    // 创建一个新的控制器类，并且分配给相应的数据
//    ContentViewController *contentVC = [[ContentViewController alloc] init];
//    contentVC.content = [self.pageContentArray objectAtIndex:index];
//    return contentVC;
//}
//
//#pragma mark - 数组元素值，得到下标值
//
//- (NSUInteger)indexOfViewController:(ContentViewController *)viewController {
//    return [self.pageContentArray indexOfObject:viewController.content];
//}

@end
