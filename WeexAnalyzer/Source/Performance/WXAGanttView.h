//
//  WXAInteractionView.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/13.
//

#import <UIKit/UIKit.h>
#import "WXAGanttData.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXAGanttView : UIView

@property(nonatomic, copy) NSArray *axisYData;
@property(nonatomic, copy) NSArray *axisXData;

@property(nonatomic, assign) double axisMaxY;
@property(nonatomic, assign) double secondOpenTime;

@property(nonatomic, copy) NSArray<WXAGanttShowData *> *datas;

@end

NS_ASSUME_NONNULL_END
