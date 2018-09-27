//
//  WXAGanttData.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXAGanttShowData : NSObject

- (instancetype)initWithName:(NSString *)name
                       start:(double)start
                         end:(double)end;

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) double start;
@property(nonatomic, assign) double end;

@end


@interface WXAGanttData : NSObject

@property (nonatomic, strong) WXAGanttShowData *downloadBundle;
@property (nonatomic, strong) WXAGanttShowData *handleBundle;
@property (nonatomic, strong) WXAGanttShowData *firstIneractionView;
@property (nonatomic, strong) WXAGanttShowData *async;
@property (nonatomic, strong) WXAGanttShowData *interaction;
@property(nonatomic, assign) double secondOpenTime;

+ (instancetype)dataWithMonitor:(NSDictionary *)monitor;

@end

NS_ASSUME_NONNULL_END
