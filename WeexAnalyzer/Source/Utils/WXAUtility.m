//
//  WXAUtility.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/20.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXAUtility.h"
#import <objc/runtime.h>
#import "WXAViewControllerUtil.h"
#import <WeexSDK/WXSDKManager.h>
#import "WeexAnalyzerDefine.h"

void WXASwapInstanceMethods(Class cls, SEL original, SEL replacement)
{
#ifdef WXADevMode
    Method originalMethod = class_getInstanceMethod(cls, original);
    IMP originalImplementation = method_getImplementation(originalMethod);
    const char *originalArgTypes = method_getTypeEncoding(originalMethod);
    
    Method replacementMethod = class_getInstanceMethod(cls, replacement);
    IMP replacementImplementation = method_getImplementation(replacementMethod);
    const char *replacementArgTypes = method_getTypeEncoding(replacementMethod);
    
    if (class_addMethod(cls, original, replacementImplementation, replacementArgTypes)) {
        class_replaceMethod(cls, replacement, originalImplementation, originalArgTypes);
    } else {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
#endif
}

@implementation WXAUtility

+ (WXSDKInstance *)findCurrentWeexInstance {
    UIViewController *vc = [WXAViewControllerUtil getNormalRootViewController];
    NSArray<WXSDKInstance *> *instanceArray = [self getAllInstances];
    
    for (WXSDKInstance *instance in instanceArray) {
        if ([instance.viewController isEqual:vc]) {
            return instance;
            break;
        }
        if ([instance.rootView isEqual:vc.view]) {
            return instance;
            break;
        }
    }
    
    return nil;
}

+ (NSArray *)getAllInstances {
    typedef WXSDKManager* (*myMethod)(id receiver, SEL selector);
    myMethod method = (myMethod)[WXSDKManager methodForSelector:NSSelectorFromString(@"sharedInstance")];
    if (method) {
        WXSDKManager *manager = method([WXSDKManager class], NSSelectorFromString(@"sharedInstance"));
        if (manager) {
            unsigned  int count = 0;
            objc_property_t *properties = class_copyPropertyList([WXSDKManager class], &count);
            
            for (int i = 0; i < count; i++) {
                objc_property_t property = properties[i];
                NSString *propName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                if ([@"instanceDict" isEqualToString:propName]) {
                    NSDictionary *value = [manager valueForKey:propName];
                    return [value allValues];
                }
            }
        }
    }
    
    return nil;
}

@end
