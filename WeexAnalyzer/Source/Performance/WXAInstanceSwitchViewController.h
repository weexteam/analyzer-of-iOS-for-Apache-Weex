//
//  WXAInstanceSwitchViewController.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXAInstanceSwitchViewController : UIViewController

@end

@interface WXAInstanceTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *instanceLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
