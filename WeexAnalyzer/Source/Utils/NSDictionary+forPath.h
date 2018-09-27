//
//  NSDictionary+forPath.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (forPath)

- (id)objectForPath:(NSString *)key;

- (NSString *)toString;

@end

NS_ASSUME_NONNULL_END
