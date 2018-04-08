//
//  WXABaseViewController.m
//  Pods-Example
//
//  Created by 对象 on 2018/3/15.
//

#import "WXABaseViewController.h"
#import "WXAUtility.h"

@implementation WXABaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = nil;
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(25, 150, self.view.bounds.size.width-50, WXA_SCREEN_HEIGHT - 100)];
    _mainView.layer.shadowColor = [UIColor blackColor].CGColor;
    _mainView.layer.shadowOffset = CGSizeMake(0,0);
    _mainView.layer.shadowOpacity = 0.8;
    _mainView.layer.shadowRadius = 5;
    _mainView.layer.backgroundColor = UIColor.whiteColor.CGColor;
    [self.view addSubview:_mainView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mainView.bounds.size.width, 50)];
    topView.backgroundColor = UIColor.whiteColor;
    [_mainView addSubview:topView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, topView.bounds.size.width - 50 , 50)];
    [topView addSubview:_titleLabel];
    
    UIButton *closeButton = [UIButton new];
    closeButton.frame = CGRectMake(topView.bounds.size.width - 36, 13, 24, 24);
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    closeButton.layer.cornerRadius = 12;
    closeButton.backgroundColor = UIColor.grayColor;
    [topView addSubview:closeButton];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, _mainView.bounds.size.width, _mainView.bounds.size.height - topView.bounds.size.height)];
    [_mainView addSubview:_contentView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self) welf = self;
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        welf.mainView.frame = CGRectMake(25, 50, self.view.bounds.size.width-50, WXA_SCREEN_HEIGHT - 100);
//        welf.view.alpha = 0.5;
    }                completion:nil];
    
}

- (void)close {
    self.view.window.hidden = YES;
}

@end
