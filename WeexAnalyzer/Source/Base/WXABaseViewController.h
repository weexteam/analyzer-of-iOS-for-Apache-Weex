//
//  WXABaseViewController.h
//  Pods-Example
//
//  Created by 对象 on 2018/3/15.
//

#import <UIKit/UIKit.h>

@interface WXABaseViewController : UIViewController <UINavigationControllerDelegate>

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *mainView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *topView;

- (BOOL)pointInside:(CGPoint)point withEvent:event;

- (void)windowResize:(CGSize)size;

- (void)addBarItemWith:(NSString *)title action:(SEL)action to:(id)target;

@end
