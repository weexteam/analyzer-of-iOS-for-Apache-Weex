//
//  WXALogMenuItem.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/11/23.
//  Copyright © 2016年 Taobao. All rights reserved.
//

#import "WXALogMenuItem.h"
#import "WXALogManager.h"
#import "WXAWXExternalLogger.h"

@interface WXALogMenuItem ()

@property (nonatomic, strong) WXALogManager *manager;
@property (nonatomic, strong) id<WXALogProtocol> logger;

@end

@implementation WXALogMenuItem

- (instancetype)initWithTitle:(NSString *)title
                iconImageName:(NSString *)iconImageName
                       logger:(id<WXALogProtocol>)logger {
    if (self = [super init]) {
        self.title = title;
        if (iconImageName) {
            self.iconImage = [UIImage imageNamed:iconImageName];
        }
        self.logger = logger;
        __weak typeof(self) welf = self;
        self.handler = ^(BOOL selected) {
            if (selected) {
                [welf.manager show];
            } else {
                [welf.manager hide];
            }
        };
    }
    return self;
}

- (void)dealloc {
    [_manager free];
}

#pragma mark - Getters
- (WXALogManager *)manager {
    if (!_manager) {
        _manager = [[WXALogManager alloc] init];
        [_manager registerLogger:_logger];
    }
    return _manager;
}

@end
