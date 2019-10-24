//
//  WXABaseViewController.h
//  Pods-Example
//
//  Created by 对象 on 2018/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXABaseViewController : UIViewController <UINavigationControllerDelegate>

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *mainView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) UIButton *resizeButton;
@property(nonatomic, assign) BOOL isShowFullScreen;
@property(nonatomic, assign) CGFloat minContentHeight;

- (BOOL)pointInside:(CGPoint)point withEvent:event;

- (void)windowResize:(CGSize)size;

- (void)addBarItemWith:(NSString *)title action:(SEL)action to:(id)target;

@end

NS_ASSUME_NONNULL_END
