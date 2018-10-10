//
//  WXABaseViewController.m
//  Pods-Example
//
//  Created by 对象 on 2018/3/15.
//

#import "WXABaseViewController.h"
#import "WXAUtility.h"

@interface WXABaseViewController ()

@property(nonatomic, assign) CGFloat startY;
@property(nonatomic, strong) UIView *sliderView;

@end

@implementation WXABaseViewController

- (instancetype)init {
    if(self = [super init]) {
        self.title = @"";
    }
    return self;
}

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = nil;
    
    CGFloat statusBarHeight = WXA_SCREEN_HEIGHT >= 812 ? 44 : 20;
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [self mainHeight])];
    _mainView.layer.backgroundColor = nil;
    _mainView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view addSubview:_mainView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mainView.bounds.size.width, statusBarHeight + 44)];
//    topView.backgroundColor = nil;
    [_mainView addSubview:_topView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, statusBarHeight, _topView.bounds.size.width - 44 , 44)];
    _titleLabel.textColor = UIColor.whiteColor;
    _titleLabel.text = [@"≡ " stringByAppendingString:self.title];
    [_topView addSubview:_titleLabel];
    
    _closeButton = [UIButton new];
    _closeButton.frame = CGRectMake(_topView.bounds.size.width - 36, statusBarHeight + 13, 24, 24);
    [_closeButton setTitle:@"×" forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeSelf:) forControlEvents:UIControlEventTouchUpInside];
//    closeButton.layer.cornerRadius = 12;
//    closeButton.backgroundColor = UIColor.grayColor;
    [_topView addSubview:_closeButton];
    
    _resizeButton = [UIButton new];
    _resizeButton.frame = CGRectMake(_topView.bounds.size.width - 80, statusBarHeight + 13, 44, 24);
    [_resizeButton setTitle:@"全屏" forState:UIControlStateNormal];
    [_resizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_resizeButton addTarget:self action:@selector(resize:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_resizeButton];
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.bounds.size.height-1, WXA_SCREEN_WIDTH, 1/UIScreen.mainScreen.scale)];
    borderView.backgroundColor = UIColor.whiteColor;
    [_topView addSubview:borderView];
    
    UIPanGestureRecognizer *panGuesture = [[UIPanGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(handlePan:)];
    [_topView addGestureRecognizer:panGuesture];
//    [self.navigationController.navigationBar addGestureRecognizer:panGuesture];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height, _mainView.bounds.size.width, _mainView.bounds.size.height - _topView.bounds.size.height - 30)];
    _contentView.backgroundColor = nil;
    [_mainView addSubview:_contentView];
    
    self.navigationController.delegate = self;
    
    //pan move view
    UIView *sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainView.frame.size.height-30, _mainView.bounds.size.width, 30)];
    sliderView.backgroundColor = UIColor.clearColor;
    UILabel *label = [[UILabel alloc] initWithFrame:sliderView.bounds];
    label.text = @"≡";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = UIColor.whiteColor;
    [sliderView addSubview:label];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WXA_SCREEN_WIDTH, 1/UIScreen.mainScreen.scale)];
    line.backgroundColor = UIColor.whiteColor;
    [sliderView addSubview:line];
    [_mainView addSubview:sliderView];
    UIPanGestureRecognizer *sliderPanGuesture = [[UIPanGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(handlePan:)];
    [sliderView addGestureRecognizer:sliderPanGuesture];
    _sliderView = sliderView;
    
}

- (void)addBarItemWith:(NSString *)title action:(SEL)action to:(id)target {
    CGFloat statusBarHeight = WXA_SCREEN_HEIGHT >= 812 ? 44 : 20;
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(_topView.bounds.size.width - 80 - 44, statusBarHeight + 13, 44, 24);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self) welf = self;
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        welf.mainView.transform = CGAffineTransformIdentity;
        welf.mainView.alpha = 1;
    }                completion:nil];
    
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGRect frame = self.view.frame;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startY = self.view.frame.origin.y;
    }
    CGPoint translationInView = [recognizer translationInView:self.view];
    CGFloat y = MAX(0, _startY + translationInView.y);
    CGFloat navBarHeight = WXA_SCREEN_HEIGHT >= 812 ? 88 : 64;
    if (y +  navBarHeight > UIScreen.mainScreen.bounds.size.height) {
        return;
    }
    frame.origin.y = y;
    
    self.view.frame = frame;
}

- (void)closeSelf:(id)sendor {
    [self.view.window setHidden:YES];
    self.view.window.rootViewController = nil;
}

- (void)resize:(UIButton *)sendor {
    CGRect viewFrame,mainFrame;
    CGFloat sliderHeight = 30;
    if ([sendor.titleLabel.text isEqualToString:@"全屏"]) {
        [sendor setTitle:@"半屏" forState:UIControlStateNormal];
        mainFrame = self.view.bounds;
        viewFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        sliderHeight = 0;
    } else {
        [sendor setTitle:@"全屏" forState:UIControlStateNormal];
        mainFrame = CGRectMake(0, 0, self.view.bounds.size.width, [self mainHeight]);
        viewFrame = self.view.frame;
        sliderHeight = 30;
    }
    self.view.frame = viewFrame;
    CGRect contentFrame = CGRectMake(0, _topView.frame.size.height, mainFrame.size.width, mainFrame.size.height - _topView.bounds.size.height - sliderHeight);
    CGRect sliderFrame = CGRectMake(0, _topView.frame.size.height+contentFrame.size.height, mainFrame.size.width, sliderHeight);
    __weak typeof(self) welf = self;
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        welf.mainView.transform = CGAffineTransformIdentity;
        welf.mainView.frame = mainFrame;
        welf.contentView.frame = contentFrame;
        welf.sliderView.frame = sliderFrame;
        [welf windowResize:contentFrame.size];
    } completion:nil];
}

- (CGFloat)mainHeight {
    CGFloat statusBarHeight = WXA_SCREEN_HEIGHT >= 812 ? 44 : 20;
    return _minContentHeight ? _minContentHeight + statusBarHeight + 44 : WXA_SCREEN_HEIGHT/2;
}

- (void)windowResize:(CGSize)size {
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:event {
    CGPoint pointInView = [self.mainView convertPoint:point fromView:self.view.window];
    return [self.mainView pointInside:pointInView withEvent:event];
}

- (void)setIsShowFullScreen:(BOOL)isShowFullScreen {
    _isShowFullScreen = isShowFullScreen;
    _resizeButton.hidden = !isShowFullScreen;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isBaseViewController = [viewController isKindOfClass:WXABaseViewController.class];
    [viewController.navigationController setNavigationBarHidden:isBaseViewController animated:YES];
}

@end
