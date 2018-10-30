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

- (void)setImage:(id)img
{
    if ([img isKindOfClass:[NSString class]]) {
        if ([img hasPrefix:@"http"]) {
            
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
    }
    return _imageView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end
