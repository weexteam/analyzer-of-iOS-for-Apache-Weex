//
//  WXAGanttData.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import "WXAGanttData.h"
#import "NSDictionary+forPath.h"

@implementation WXAGanttShowData

- (instancetype)initWithName:(NSString *)name
                       start:(double)start
                         end:(double)end {
    
    if (self = [super init]) {
        self.name = name;
        self.start = start;
        self.end = end;
    }
    return self;
}

@end


@implementation WXAGanttData

+ (instancetype)dataWithMonitor:(NSDictionary *)monitor {
    return [[self alloc] initWithMonitor:monitor];
}

- (instancetype)initWithMonitor:(NSDictionary *)monitor {
    if (self = [self init]) {
        NSNumber *wxStartDownLoadBundle = [monitor objectForPath:@"stage.wxStartDownLoadBundle"] ?: @0;
        NSNumber *wxEndDownLoadBundle = [monitor objectForPath:@"stage.wxEndDownLoadBundle"] ?: @0;
        NSNumber *wxRenderTimeOrigin = [monitor objectForPath:@"stage.wxRenderTimeOrigin"] ?: @0;
        NSNumber *wxEndLoadBundle = [monitor objectForPath:@"stage.wxEndLoadBundle"] ?: @0;
        NSNumber *wxFirstInteractionView = [monitor objectForPath:@"stage.wxFirstInteractionView"] ?: @0;
        NSNumber *wxJSAsyncDataStart = [monitor objectForPath:@"stage.wxJSAsyncDataStart"] ?: @0;
        NSNumber *wxJSAsyncDataEnd = [monitor objectForPath:@"stage.wxJSAsyncDataEnd"] ?: @0;
        NSNumber *wxInteraction = [monitor objectForPath:@"stage.wxInteraction"] ?: @0;
        _downloadBundle = [[WXAGanttShowData alloc] initWithName:@"请求资源耗时"
                                                           start:0
                                                             end:(wxEndDownLoadBundle.doubleValue - wxStartDownLoadBundle.doubleValue)];
        _handleBundle = [[WXAGanttShowData alloc] initWithName:@"处理bundle耗时"
                                                           start:(wxRenderTimeOrigin.doubleValue - wxStartDownLoadBundle.doubleValue)
                                                             end:(wxEndLoadBundle.doubleValue - wxStartDownLoadBundle.doubleValue)];
        _firstIneractionView = [[WXAGanttShowData alloc] initWithName:@"第一个view出现"
                                                         start:(wxEndLoadBundle.doubleValue - wxStartDownLoadBundle.doubleValue)
                                                           end:(wxFirstInteractionView.doubleValue - wxStartDownLoadBundle.doubleValue)];
        _async = [[WXAGanttShowData alloc] initWithName:@"业务异步耗时"
                                                                start:(wxJSAsyncDataStart.doubleValue - wxStartDownLoadBundle.doubleValue)
                                                                  end:(wxJSAsyncDataEnd.doubleValue - wxStartDownLoadBundle.doubleValue)];
        _interaction = [[WXAGanttShowData alloc] initWithName:@"可交互时间"
                                                                start:0
                                                                  end:(wxInteraction.doubleValue - wxStartDownLoadBundle.doubleValue)];
        _secondOpenTime = _interaction.end/2.0;
        
    }
    return self;
}

@end
