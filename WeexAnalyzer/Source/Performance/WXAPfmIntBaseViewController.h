//
//  WXAPfmIntBaseViewController.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXAPfmIntBaseViewController : UIViewController

@property(nonatomic, strong) NSString *instanceId;
@property(nonatomic, copy, readonly) NSString *type;

- (void)load;
- (void)reload;

@end

NS_ASSUME_NONNULL_END
