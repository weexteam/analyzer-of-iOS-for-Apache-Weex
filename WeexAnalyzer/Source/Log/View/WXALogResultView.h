//
//  WXALogResultView.h
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/27.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXALogResultView : UITableView

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) BOOL autoScroll;

- (void)reloadResults;

@end
