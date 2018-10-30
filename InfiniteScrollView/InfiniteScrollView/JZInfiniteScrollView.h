//
//  InfiniteScrollView.h
//  InfiniteScrollView
//
//  Created by Allen on 2018/10/29.
//  Copyright © 2018年 daojia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JZInfiniteScrollView;

/**
 无限轮播图 代理、DataSource
 */
@protocol JZInfiniteScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView;

- (CGSize)sizeOfItemForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView;


@optional
/* item Image */
- (NSArray *)imagesForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView;

/* cell 间距 */
- (CGFloat)minimItemSpacingForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView;


/**
 用于深度自定义cell样式的class
 
 @return a class
 */
- (Class)itemClassForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView;

/**
 深度自定义的回调cellDatas赋值
 
 @return cellDatas
 */
- (NSArray *)cellDatasForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView;

@end


NS_ASSUME_NONNULL_BEGIN

@interface JZInfiniteScrollView : UICollectionView

@property (nonatomic, weak) id<JZInfiniteScrollViewDataSource>jzDataSource;

/* 自动滚动时间建个 */
@property (nonatomic, assign) NSTimeInterval timeInterval;
/* 是否开启无限滚动 要放在reload之前设置 */
@property (nonatomic, assign, getter=isInfinite) BOOL infinite;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
