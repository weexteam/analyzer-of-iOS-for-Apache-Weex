//
//  WXAInteractionView.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/13.
//

#import "WXAGanttView.h"
#import "UIColor+WXAExtension.h"

@implementation WXAGanttView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect axisRect = CGRectMake(rect.origin.x+15, rect.origin.y+15, rect.size.width-30, rect.size.height-30);
    [self drawAxis:context rect:axisRect];
    [self drawData:context rect:axisRect];
    [self drawSecondOpen:context rect:axisRect];
}

- (void)drawAxis:(CGContextRef)context rect:(CGRect)rect {
    
    CGContextSetStrokeColorWithColor(context, UIColor.whiteColor.CGColor);
    CGContextSetLineWidth(context, 1);
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(context, minX, minY);
    CGContextAddLineToPoint(context, minX, maxY);
    CGContextMoveToPoint(context, minX, minY);
    CGContextAddLineToPoint(context, minX+2, minY+5);
    CGContextMoveToPoint(context, minX, minY);
    CGContextAddLineToPoint(context, minX-2, minY+5);
    CGContextMoveToPoint(context, maxX, maxY);
    CGContextAddLineToPoint(context, minX, maxY);
    CGContextMoveToPoint(context, maxX, maxY);
    CGContextAddLineToPoint(context, maxX-5, maxY-2);
    CGContextMoveToPoint(context, maxX, maxY);
    CGContextAddLineToPoint(context, maxX-5, maxY+2);
    CGContextStrokePath(context);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10],
                                NSFontAttributeName, UIColor.whiteColor, NSForegroundColorAttributeName, nil];
    float interval = _axisMaxY/5.0;
    float intervalWidth = rect.size.width*0.9/5.0;
    for (int i=0; i<6; i++) {
        CGPoint titlePoint = CGPointMake(minX+intervalWidth*i, maxY);
        NSString *axisYtitle = [NSString stringWithFormat:@"%.1f", interval*i];
        [axisYtitle drawAtPoint:titlePoint withAttributes:attributes];
        
        if (i>0) {
            //纵向分割线
            CGFloat lengths[] = {4,2};
            CGContextSetLineDash(context, 5, lengths, 2);
            CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor.CGColor);
            CGContextMoveToPoint(context, titlePoint.x, maxY);
            CGContextAddLineToPoint(context, titlePoint.x, minY);
            CGContextStrokePath(context);
        }
    }
    
}

- (void)drawData:(CGContextRef)context rect:(CGRect)rect {
    
    CGFloat minY = rect.origin.y + rect.size.height * 0.1;
    CGFloat mainWidth = rect.size.width*0.9;
    CGFloat itemHeight =  rect.size.height * 0.9 / self.datas.count;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],
                                NSFontAttributeName, UIColor.whiteColor, NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    for (int i=0; i<self.datas.count; i++) {
        WXAGanttShowData *data = self.datas[i];
        CGFloat x = CGRectGetMinX(rect) + data.start/_axisMaxY*mainWidth;
        CGFloat width = (data.end-data.start)/_axisMaxY*mainWidth;
        CGFloat y = minY + i*itemHeight;
        
        CGContextSetFillColorWithColor(context, UIColor.wxaHighlightRectColor.CGColor);
        CGContextFillRect(context, CGRectMake(x, y, width, 20));
        
        [data.name drawAtPoint:CGPointMake(x, y+22) withAttributes:attributes];
        
        CGFloat durationWidth = width < 100 ? 100 : width;
        paragraphStyle.alignment = width < 100 ? NSTextAlignmentLeft : NSTextAlignmentCenter;
        [data.duration drawInRect:CGRectMake(x, y+3, durationWidth, 20) withAttributes:attributes];
    }
    
}

- (void)drawSecondOpen:(CGContextRef)context rect:(CGRect)rect {
    if (_axisMaxY<=0 || _secondOpenTime <= 0) {
        return;
    }
    CGFloat x = rect.origin.x + CGRectGetWidth(rect) * _secondOpenTime/_axisMaxY;
    
    CGFloat lengths[] = {10,2};
    CGContextSetLineDash(context, 5, lengths, 2);
    CGContextSetStrokeColorWithColor(context, UIColor.orangeColor.CGColor);
    CGContextMoveToPoint(context, x, CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, x, CGRectGetMaxY(rect)+10);
    CGContextStrokePath(context);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],
                                NSFontAttributeName, UIColor.orangeColor, NSForegroundColorAttributeName, nil];
    NSString *text = [NSString stringWithFormat:@"%.1f (原秒开时间)", _secondOpenTime];
    [text drawAtPoint:CGPointMake(x+5, CGRectGetMinY(rect)) withAttributes:attributes];
}

@end
