//
//  JZInfiniteItemCell.m
//  InfiniteScrollView
//
//  Created by Allen on 2018/10/29.
//  Copyright © 2018年 daojia. All rights reserved.
//

#import "JZInfiniteItemCell.h"

@interface JZInfiniteItemCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JZInfiniteItemCell

#pragma mark
#pragma mark - 懒加载

- (void)setImage:(id)img{
    [self setImage:img placeholderImg:nil];
}

- (void)setImage:(id)img placeholderImg:(UIImage *)placeImg
{
    if ([img isKindOfClass:[NSString class]]) {
        if ([[img lowercaseString] hasPrefix:@"http://"]
            ||[[img lowercaseString] hasPrefix:@"https://"])
        {
            // 可以依赖SD_Image库来做异步加载
            //[self.imageView sd_setImageWithURL:[NSURL URLWithString:img?:@""] placeholderImage:placeImg];
        }else{
            self.imageView.image = [UIImage imageNamed:img];
        }
    }else if([img isKindOfClass:[UIImage class]]){
        [self.imageView setImage:img];
    }
}

- (UIImageView *)imageView{
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end
