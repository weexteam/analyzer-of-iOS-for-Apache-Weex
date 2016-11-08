//
//  WXABaseContentView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/8.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXABaseContentView.h"

@implementation WXABaseContentView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.onContentSizeChanged) {
        self.onContentSizeChanged(self.frame);
    }
}

@end
