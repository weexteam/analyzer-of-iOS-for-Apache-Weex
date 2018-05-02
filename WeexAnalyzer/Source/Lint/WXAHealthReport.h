//
//  WXAHealthReport.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/4/16.
//

#import <Foundation/Foundation.h>

@interface WXAHealthReport : NSObject

@property (nonatomic, assign) BOOL hasList;
@property (nonatomic, assign) BOOL hasScroller;
@property (nonatomic, assign) BOOL hasBigCell;
@property (nonatomic, assign) int maxLayerOfVDom;
@property (nonatomic, assign) int maxLayerOfRealDom;
@property (nonatomic, assign) int componentNumOfBigCell;
@property (nonatomic, assign) BOOL hasEmbed;

@property (nonatomic, assign) int estimateContentHeight;
@property (nonatomic, assign) int estimatePages;


@end
