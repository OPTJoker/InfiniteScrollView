# InfiniteScrollView
轻量级无限轮播图

初始化
```objc
- (JZInfiniteScrollView *)infinitScroll{
    if (nil == _infinitScroll) {
        _infinitScroll = [[JZInfiniteScrollView alloc] initWithFrame:CGRectMake(10, 60, 355, 160)];
        _infinitScroll.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.view addSubview:_infinitScroll];
        _infinitScroll.jzDataSource = self;
        _infinitScroll.infinite = YES;
        _infinitScroll.timeInterval = 2;
    }
    return _infinitScroll;
}
```

代理回调
````objc

#pragma mark
#pragma mark - 不自定义cell代理方法
////////// Required 代理
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

////////// Optional 代理
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
````
