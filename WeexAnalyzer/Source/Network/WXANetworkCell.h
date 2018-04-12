//
//  WXANetworkCell.h
//  WeexAnalyzerBundle
//
//  Created by 对象 on 2018/3/21.
//

#import <UIKit/UIKit.h>
#import "WXNetworkTransaction.h"

@interface WXANetworkCell : UITableViewCell

@property(nonatomic, strong) UILabel *label;

@property (nonatomic, strong) WXNetworkTransaction *transaction;

+ (CGFloat)preferredCellHeight;

@end
