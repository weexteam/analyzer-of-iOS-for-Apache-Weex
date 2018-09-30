//
//  WXAPfmIntBaseViewController.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/28.
//

#import "WXAPfmIntBaseViewController.h"
#import "WXAMonitorDataManager.h"

@interface WXAPfmIntBaseViewController ()

@end

@implementation WXAPfmIntBaseViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(instanceChanged:)
                                               name:kWXAMonitorSelectNotification                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(transfer:)
                                               name:kWXAMonitorHandlerNotification
                                             object:nil];
    [self load];
}

- (void)instanceChanged:(NSNotification *)notification {
    NSString *instanceId = [notification.object objectForKey:@"instanceId"];
    if (_instanceId == instanceId) {
        return;
    }
    _instanceId = instanceId;
    [self reload];
}

- (void)transfer:(NSNotification *)notification {
    NSString *instanceId = [notification.object objectForKey:@"instanceId"];
    NSString *type = [notification.object objectForKey:@"type"];
    if (![instanceId isEqualToString:_instanceId]) {
        return;
    }
    if (![type isEqualToString:self.type]) {
        return;
    }
    [self reload];
}

- (void)load {
    
}

- (void)reload {
    
}

@end
