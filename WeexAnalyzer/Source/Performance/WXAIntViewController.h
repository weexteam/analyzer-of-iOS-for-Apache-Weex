//
//  WXAIntViewController.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import <UIKit/UIKit.h>
#import "WXAPfmIntBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXAIntViewController : WXAPfmIntBaseViewController

@end

@interface WXAInteractionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *diffTimeLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *refLabel;
@property (nonatomic, strong) UILabel *styleLabel;
@property (nonatomic, strong) UILabel *attrsLabel;

@end

NS_ASSUME_NONNULL_END
