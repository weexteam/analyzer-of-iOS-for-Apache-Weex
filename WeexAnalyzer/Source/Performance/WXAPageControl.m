//
//  WXAPageControl.m
//  WeexAnalyzer
//
//  Created by 对象 on 2018/9/27.
//

#import "WXAPageControl.h"

@implementation WXAPageControl

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        if (subviewIndex == page){
            UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
            CGSize size;
            size.height = 10;
            size.width = 10;
            [subview setFrame:CGRectMake(subview.frame.origin.x,subview.frame.origin.y,size.width,size.height)];
        }
    }
}


@end
