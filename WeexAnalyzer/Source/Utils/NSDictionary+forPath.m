//
//  NSDictionary+forPath.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import "NSDictionary+forPath.h"

@implementation NSDictionary (forPath)

- (id)objectForPath:(NSString *)path {
    if (![path isKindOfClass:NSString.class]) {
        return nil;
    }
    if ([path containsString:@"."]) {
        NSArray *keys = [path componentsSeparatedByString:@"."];
        NSDictionary *dict = self;
        for (int i=0; i<keys.count; i++) {
            dict = [dict objectForKey:keys[i]];
            if (i == keys.count-1) {
                return dict;
            } else {
                if (![dict isKindOfClass:NSDictionary.class]) {
                    return nil;
                }
            }
        }
    } else {
        return [self objectForKey:path];
    }
    return nil;
}

- (NSString *)toString {
    NSString *jsonString = @"";
    @try {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:0
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    } @catch (NSException *exception) {
        NSLog(@"serialize error: %@", exception.reason);
    }
    return jsonString;
}

@end
