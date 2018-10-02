//
//  WXAMenuView.m
//  WeexAnalyzer
//
//  Created by xiayun on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WXAMenuView.h"
#import "UIView+WXAPopover.h"
#import "WXAUtility.h"
#import "WXAMenuProtocol.h"
#import "WXAMenuCell.h"

#define WXAMenuCellID @"WXACell"
#define WXAMenuHeaderID @"WXAHeader"

@interface WXAMenuView () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIView *wrapView;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) NSArray<WXAMenuItem *> *items;
@property(nonatomic, strong) id<WXAMenuProtocol> menu;
@property(nonatomic, assign) NSInteger showCount;

@end

@implementation WXAMenuView

- (instancetype)initWithItems:(NSArray<WXAMenuItem *> *)items {
    if (self = [super init]) {
        _items = items;
        [self initMenu];
    }
    return self;
}

- (void)initMenu {
    _menu = [WXSDKEngine handlerForProtocol:@protocol(WXAMenuProtocol)];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    self.frame = frame;
    
    _maskView = [[UIView alloc] initWithFrame:frame];
    _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self addSubview:_maskView];
    
    _wrapView = [[UIView alloc] initWithFrame:_menu.frame];
    _wrapView.layer.shadowColor = [UIColor blackColor].CGColor;
    _wrapView.layer.shadowOffset = CGSizeMake(0,0);
    _wrapView.layer.shadowOpacity = 0.8;
    _wrapView.layer.shadowRadius = 5;
    _wrapView.layer.backgroundColor = UIColor.whiteColor.CGColor;
    [self addSubview:_wrapView];
    
    [_wrapView addSubview:_menu.headerView];
    
    CGRect collectionViewframe = _wrapView.bounds;
    CGFloat spacing = 1/UIScreen.mainScreen.scale;
    CGFloat realItemWidth = [self fixSlitWith:collectionViewframe.size.width colCount:3 space:spacing];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(realItemWidth, realItemWidth);
    layout.minimumLineSpacing = spacing;
    layout.minimumInteritemSpacing = spacing;
    CGFloat realWidth = 3 * realItemWidth + 2 * spacing;
    collectionViewframe.origin.x = (collectionViewframe.size.width - realWidth)/2;
    collectionViewframe.origin.y = _menu.headerHeight;
    collectionViewframe.size.width = 3 * realItemWidth + 2 * spacing;
    collectionViewframe.size.height = collectionViewframe.size.height - _menu.headerHeight;
    _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewframe collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.layer.cornerRadius = 2;
    _collectionView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:WXAMenuCell.class forCellWithReuseIdentifier:WXAMenuCellID];
    [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WXAMenuHeaderID];
    [_wrapView addSubview:_collectionView];
    _showCount = 3 * ceil(collectionViewframe.size.height / collectionViewframe.size.width * 3);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
    tap.delegate = self;
    [_maskView addGestureRecognizer:tap];
}

- (CGFloat)fixSlitWith:(CGFloat)width colCount:(CGFloat)colCount space:(CGFloat)space {
    CGFloat totalSpace = (colCount - 1) * space;
    CGFloat itemWidth = (width - totalSpace) / colCount;
    CGFloat fixValue = 1 / [UIScreen mainScreen].scale;
    CGFloat realItemWidth = floor(itemWidth) + fixValue;
    if (realItemWidth < itemWidth) {
        realItemWidth += fixValue;
    }
    return realItemWidth;
}

- (void)showMenu {
    __weak typeof(self) welf = self;
    [self WeexAnalyzer_popover:^{
        welf.maskView.alpha = 0;
        CGFloat y = welf.wrapView.frame.origin.y;
        welf.wrapView.frame = CGRectMake(welf.wrapView.frame.origin.x, WXA_SCREEN_HEIGHT, welf.wrapView.frame.size.width, welf.wrapView.frame.size.height);
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            welf.wrapView.frame = CGRectMake(welf.wrapView.frame.origin.x, y, welf.wrapView.frame.size.width, welf.wrapView.frame.size.height);
            welf.maskView.alpha = 0.5;
        }                completion:nil];
    }];
}

- (void)closeMenu:(UITapGestureRecognizer *)tap {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _showCount > _items.count ? _showCount : _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WXAMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WXAMenuCellID forIndexPath:indexPath];
    if (cell) {
        if (indexPath.row < _items.count) {
            WXAMenuItem *item = _items[indexPath.row];
            cell.label.text = item.title;
            [cell.icon setImage:item.iconImage];
        } else {
            cell.label.text = @"";
            [cell.icon setImage:nil];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _items.count) {
        WXAMenuItem *item = _items[indexPath.row];
        [item open:YES];
        [self closeMenu:nil];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
