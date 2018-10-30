//
//  InfiniteScrollView.m
//  InfiniteScrollView
//
//  Created by Allen on 2018/10/29.
//  Copyright © 2018年 daojia. All rights reserved.
//

#import "JZInfiniteScrollView.h"
#import "JZInfiniteItemCell.h"
#import "JZInfiniteCustomCellProtocol.h"

NSString * const KJZInfiniteCellIDE = @"JZInfiniteCellIDE";
NSString * const KJZInfiniteCustomCellIDE = @"KJZInfiniteCustomCellIDE";

CGFloat KScreenW;
CGFloat KScreenH;
NSTimeInterval const animIntval = 0.15;

typedef NS_ENUM(NSUInteger, KScrollDirection) {
    KScrollDirection_Left = 0,
    KScrollDirection_Right = 1
};

@interface JZInfiniteScrollView ()
<UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
{
    CGFloat historyX; //上次偏移量
    KScrollDirection scrollDirection; //滚动方向
    NSInteger curIndex; //当前下标
    CGSize itemSize; //cell大小
    CGFloat itemSpace; //cell间距
    BOOL needScrollItem; //是否需要滚动item位置
}
@property (nonatomic, strong) Class customItemClass;
@property (nonatomic, strong) NSArray *datas; //自定义cell的数据源

@property (nonatomic, strong) NSArray *imgsArr;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JZInfiniteScrollView


#pragma mark
#pragma mark - u初始化
- (instancetype)init{
    CGRect frame = CGRectZero;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [self initWithFrame:frame collectionViewLayout:layout];
    if (self) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [self initWithFrame:frame collectionViewLayout:layout];
    if (self) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    UICollectionViewFlowLayout *flLayout = (UICollectionViewFlowLayout *)layout;
    
    if ([layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        flLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    self = [super initWithFrame:frame collectionViewLayout:flLayout];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;        
        KScreenW = [UIScreen mainScreen].bounds.size.width;
        KScreenH = [UIScreen mainScreen].bounds.size.height;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[JZInfiniteItemCell class] forCellWithReuseIdentifier:KJZInfiniteCellIDE];
    
    }
    return self;
}

- (void)setJzDataSource:(id<JZInfiniteScrollViewDataSource>)jzDataSource{
    _jzDataSource = jzDataSource;
    if ([_jzDataSource respondsToSelector:@selector(itemClassForInfiniteScrollView:)]) {
        // cell注册
        Class cls = [_jzDataSource itemClassForInfiniteScrollView:self];
        if (cls) {
            self.customItemClass = cls;
            [self registerClass:cls forCellWithReuseIdentifier:KJZInfiniteCustomCellIDE];
        }else{
            [self registerClass:[JZInfiniteItemCell class] forCellWithReuseIdentifier:KJZInfiniteCellIDE];
        }
    }else{
        [self registerClass:[JZInfiniteItemCell class] forCellWithReuseIdentifier:KJZInfiniteCellIDE];
    }
}


#pragma mark
#pragma mark - LayoutSubView
- (void)layoutSubviews{
    [super layoutSubviews];
    if (!self.isInfinite) {
        // 初始化一些设置
        CGFloat hor_spc = (self.bounds.size.width - itemSize.width)/2.0;
        CGFloat ver_spc = (self.bounds.size.height - itemSize.height)/2.0;
        self.contentInset = UIEdgeInsetsMake(ver_spc, hor_spc, ver_spc, hor_spc);
    }
}

#pragma mark
#pragma mark - Getter 懒加载
- (NSTimer *)timer{
    if (_timeInterval <= 0) {
        return nil;
    }
    if (nil == _timer) {
        //__weak typeof(self) wkSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    }
    return _timer;
}


#pragma mark
#pragma mark - collection数据源 【size相关】

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.jzDataSource respondsToSelector:@selector(sizeOfItemForInfiniteScrollView:)]) {
        itemSize = [self.jzDataSource sizeOfItemForInfiniteScrollView:self];
        return itemSize;
    }else{
        itemSize = CGSizeZero;
        return itemSize;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.jzDataSource respondsToSelector:@selector(minimItemSpacingForInfiniteScrollView:)]) {
        itemSpace = [self.jzDataSource minimItemSpacingForInfiniteScrollView:self];
        return itemSpace;
    }else{
        itemSpace = 0;
        return itemSpace;
    }
}

#pragma mark - collection数据源 【number和data相关】
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.jzDataSource respondsToSelector:@selector(imagesForInfiniteScrollView:)]) {
        self.imgsArr = [self.jzDataSource imagesForInfiniteScrollView:self];
    }
    if ([self.jzDataSource respondsToSelector:@selector(cellDatasForInfiniteScrollView:)]) {
        self.datas = [self.jzDataSource cellDatasForInfiniteScrollView:self];
    }
    
    if ([self.jzDataSource respondsToSelector:@selector(numberOfItemsForInfiniteScrollView:)]) {
        self.itemCount = [self.jzDataSource numberOfItemsForInfiniteScrollView:self];
        if ([self.jzDataSource numberOfItemsForInfiniteScrollView:self]>1) {
            return self.itemCount*(self.infinite?3:1);
        }else{
            return self.itemCount;
        }
        
    }else{
        self.itemCount = 0;
        return 0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customItemClass) {
        UICollectionViewCell<JZInfiniteCustomCellProtocol>*cusCell = [self dequeueReusableCellWithReuseIdentifier:KJZInfiniteCustomCellIDE forIndexPath:indexPath];
        if ([self.jzDataSource respondsToSelector:@selector(cellDatasForInfiniteScrollView:)]) {
            if (self.datas.count > indexPath.item%self.itemCount) {
                id data = [self.datas objectAtIndex:indexPath.item%self.itemCount];
                NSLog(@"cus Data:%@", data);
                [cusCell setupCellWithData:data atIndexPath:indexPath];
            }
        }
        
        return cusCell;
    }else{
        JZInfiniteItemCell *cell = [self dequeueReusableCellWithReuseIdentifier:KJZInfiniteCellIDE forIndexPath:indexPath];
        
        if ([self.jzDataSource respondsToSelector:@selector(imagesForInfiniteScrollView:)]) {
            // 模运算取正确的值
            if (self.itemCount > 0) {
                // 放心取值操作
                if (self.imgsArr.count>indexPath.item%self.itemCount) {
                    [cell setImage:[self.imgsArr objectAtIndex:indexPath.item%self.itemCount]];
                }
            }
        }
        return cell;
    }
}


#pragma mark
#pragma mark - scrollView代理 && 手动滚动操作
- (BOOL)isValidIdx:(NSInteger)idx{
    if (0 <= idx && idx<self.itemCount*(self.infinite?3:1)) {
        return YES;
    }
    return NO;
}
//判断滑动方向用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat curX = scrollView.contentOffset.x;
    if (curX<historyX) {
        scrollDirection = KScrollDirection_Right;
    }else if (curX>historyX) {
        scrollDirection = KScrollDirection_Left;
    }
    historyX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self continueTimer];
    // 如果手离开的时候有速度
    if (decelerate) {
        if (self->scrollDirection == KScrollDirection_Left) {
            [self scrollToNextItem];
        }else{
            [self scrollToLastItem];
        }
    }else{
        [self scrollItemByOffX];
    }
}

// 开始v拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    needScrollItem = YES;
    [self pauseTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //滚动完之后回滚到中间位置
    if (self.isInfinite) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->curIndex<self.itemCount || self->curIndex > self.itemCount*2-1) {
                NSInteger temp = (self->curIndex+self.itemCount)%self.itemCount;
                self->curIndex = temp+self.itemCount;
                NSIndexPath *idxPath = [NSIndexPath indexPathForItem:self->curIndex inSection:0];
                
                [self scrollToItemAtIndexPath:idxPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
        });
    }
}


- (void)scrollToLastItem
{
    if (![self isValidIdx:curIndex-1]) {
        return;
    }
    curIndex--;
    [self scrollItemAtIdxToCenter:curIndex];
    needScrollItem = NO;
}

- (void)scrollToNextItem
{
    if (![self isValidIdx:curIndex+1]) {
        return;
    }
    curIndex++;
    [self scrollItemAtIdxToCenter:curIndex];
    needScrollItem = NO;
}
- (void)scrollItemByOffX
{
    CGFloat offx = [self Amode:self.contentOffset.x B:itemSize.width+itemSpace];
    NSInteger temp = (long)(self.contentOffset.x/(itemSize.width+itemSpace));
    // 利用中缝判断该左滑还是右滑
    if(offx> (itemSize.width-(KScreenW-itemSpace)/2.0) ) {
        if ([self isValidIdx:temp+1]) {
            curIndex = temp+1;
            [self scrollItemAtIdxToCenter:curIndex];
        }
        needScrollItem = NO;
    }else{
        if ([self isValidIdx:temp]) {
            curIndex = temp;
            [self scrollItemAtIdxToCenter:curIndex];
        }        
        needScrollItem = NO;
    }
    
}

- (void)scrollItemAtIdxToCenter:(NSInteger)idx
{
    if (!needScrollItem) {
        return;
    }
    if (idx<0 || idx>=self.itemCount*(self.infinite?3:1)) {
        return;
    }
    [UIView animateWithDuration:animIntval animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *idxPath = [NSIndexPath indexPathForItem:idx inSection:0];
            [self scrollToItemAtIndexPath:idxPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        });
    }];
    
}

- (CGFloat)Amode:(CGFloat)a B:(CGFloat)b{
    while (a>=b) {
        a-=b;
    }
    return a;
}

#pragma mark
#pragma mark - 复写系统方法
- (void)reloadData
{
    [super reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        self->historyX = self.contentOffset.x;
        if (self.itemCount>0) {
            
            NSInteger startIdx = 0;
            if (self.isInfinite) {
                NSInteger offIdx = self.itemCount;
                // midIndex是中间元素
                //NSInteger midIndex = (self.itemCount+1)/2+offIdx-1;
                startIdx = offIdx;
            }
            
            NSIndexPath *idxPath = [NSIndexPath indexPathForItem:startIdx inSection:0];
            [self scrollToItemAtIndexPath:idxPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            self->curIndex = startIdx;
        }
    });
}


#pragma mark
#pragma mark - 计数器相关
- (void)setTimeInterval:(NSTimeInterval)timeInterval{
    _timeInterval = MAX(timeInterval, animIntval);
    [self startimer];
}

- (void)timerMethod{
    //NSLog(@"timer");
    if (self.window) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->needScrollItem = YES;
            [self scrollToNextItem];
        });
    }
}

//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTimer{
    [self.timer setFireDate:[NSDate distantFuture]];
}
//继续计时
-(void)continueTimer{
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
}

//开始计时
-(void)startimer{
    [self.timer fire];
}
//暂停并销毁
-(void)stopTimer{
    [self pauseTimer];
    [self.timer invalidate];
    self.timer = nil;
}
@end
