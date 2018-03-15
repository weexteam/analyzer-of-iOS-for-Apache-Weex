//
//  WXACellView.h
//  WeexAnalyzer
//
//  Created by 对象 on 2018/3/15.
//

#import <Foundation/Foundation.h>

@interface WXACellModel : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSArray<id> *keys;
@property(nonatomic, strong) NSDictionary<id,NSString *> *dictionary;
@property(nonatomic, assign) BOOL isSingle;

@end

@interface WXACellView : UIView

@property(nonatomic, strong) NSArray<id> *result;

- (instancetype)initWithFrame:(CGRect)frame model:(WXACellModel *)model;
- (id)getSingelResult;

@end
