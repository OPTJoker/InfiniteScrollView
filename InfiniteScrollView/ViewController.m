//
//  ViewController.m
//  InfiniteScrollView
//
//  Created by Allen on 2018/10/29.
//  Copyright © 2018年 daojia. All rights reserved.
//

#import "ViewController.h"
#import "JZInfiniteScrollView.h"
#import "CustomItemCell.h"

@interface ViewController ()
<JZInfiniteScrollViewDataSource>

@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) JZInfiniteScrollView *infinitScroll;
@property (nonatomic, strong) JZInfiniteScrollView *infinitScrollMid;
@property (nonatomic, strong) JZInfiniteScrollView *infinitScroll2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
}

- (JZInfiniteScrollView *)infinitScroll{
    if (nil == _infinitScroll) {
        _infinitScroll = [[JZInfiniteScrollView alloc] initWithFrame:CGRectMake(10, 60, 355, 160)];
        _infinitScroll.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.view addSubview:_infinitScroll];
        _infinitScroll.jzDataSource = self;
        _infinitScroll.infinite = YES; //是否开启无限轮播
        _infinitScroll.timeInterval = 2; //不设置则不开启轮播计时器
    }
    return _infinitScroll;
}


- (JZInfiniteScrollView *)infinitScrollMid{
    if (nil == _infinitScrollMid) {
        _infinitScrollMid = [[JZInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 160+60+50, 375, 120)];
        [self.view addSubview:_infinitScrollMid];
        _infinitScrollMid.jzDataSource = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self->_infinitScrollMid.timeInterval = 2;
        });
        
        _infinitScrollMid.infinite = YES;
    }
    return _infinitScrollMid;
}

- (JZInfiniteScrollView *)infinitScroll2{
    if (nil == _infinitScroll2) {
        _infinitScroll2 = [[JZInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 160+60+50+120+50, 375, 240)];
        [self.view addSubview:_infinitScroll2];
        _infinitScroll2.jzDataSource = self;
        //_infinitScroll2.timeInterval = 2;
        _infinitScroll2.infinite = YES;
    }
    return _infinitScroll2;
}

- (void)fetchData{
    self.imgs = @[@"1.jpeg", @"2.jpeg", @"3.jpeg"];
    [self.infinitScroll reloadData];
    [self.infinitScrollMid reloadData];
    [self.infinitScroll2 reloadData];
}


#pragma mark
#pragma mark - 不自定义cell代理方法
////////// Required
- (NSInteger)numberOfItemsForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView {
    return self.imgs.count;
}
- (CGSize)sizeOfItemForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView {
    if (infiniteView == self.infinitScroll) {
        return CGSizeMake(305, 148);
    }else if (infiniteView == self.infinitScrollMid){
        return CGSizeMake(315, 110);
    }
    return CGSizeMake(375, 240);
}

////////// Optional
- (CGFloat)minimItemSpacingForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView {
    if (infiniteView == self.infinitScroll) {
        return 25;
    }else if (infiniteView == self.infinitScrollMid){
        return 10;
    }
    return 0;
}
- (NSArray *)imagesForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView {
    return self.imgs;
}


#pragma mark
#pragma mark - 自定义Cell 回调
- (Class)itemClassForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView {
    if (infiniteView == self.infinitScroll) {
        return [CustomItemCell class];
    }else if (infiniteView == self.infinitScrollMid){
        return [CustomItemCell class];
    }
    return nil;
}
- (NSArray *)cellDatasForInfiniteScrollView:(JZInfiniteScrollView *)infiniteView{
    return self.imgs;
}


@end
