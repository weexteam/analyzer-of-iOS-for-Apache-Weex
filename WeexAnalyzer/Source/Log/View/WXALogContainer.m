//
//  WXALogContainer.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/27.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXALogContainer.h"
#import "WXAUtility.h"

@implementation WXALogContainer

- (instancetype)initWithFrame:(CGRect)frame windowType:(WXALogWindowType)windowType {
    CGRect newFrame = [WXALogContainer frameForWindowType:windowType];
    if (self = [super initWithFrame:newFrame]) {
        self.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 0.5;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)changedWindowType:(WXALogWindowType)windowType {
    CGRect frame = [WXALogContainer frameForWindowType:windowType];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self.delegate onContainerSizeChanged];
    }];
}

+ (CGRect)frameForWindowType:(WXALogWindowType)windowType {
    switch (windowType) {
        case WXALogWindowTypeSmall:
            return CGRectMake(WXA_SCREEN_WIDTH - 110, WXA_SCREEN_HEIGHT/2, 100, 30);
        case WXALogWindowTypeMedium:
            return CGRectMake(0, WXA_SCREEN_HEIGHT-(WXA_SCREEN_HEIGHT/2), WXA_SCREEN_WIDTH, WXA_SCREEN_HEIGHT/2);
        case WXALogWindowTypeFullScreen:
            return CGRectMake(0, 20, WXA_SCREEN_WIDTH, WXA_SCREEN_HEIGHT-20);
        default:
            return CGRectMake(0, WXA_SCREEN_HEIGHT-(WXA_SCREEN_HEIGHT/2), WXA_SCREEN_WIDTH, WXA_SCREEN_HEIGHT/2);
    }
}

@end
