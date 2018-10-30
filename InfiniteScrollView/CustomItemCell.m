//
//  CustomItemCell.m
//  InfiniteScrollView
//
//  Created by Allen on 2018/10/30.
//  Copyright © 2018年 daojia. All rights reserved.
//

#import "CustomItemCell.h"

@interface CustomItemCell ()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CustomItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor brownColor];
        self.contentView.layer.cornerRadius = 4;
        self.contentView.layer.masksToBounds = YES;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}


- (void)setupCellWithData:(id)data atIndexPath:(NSIndexPath *)indexPath{
    [self setImage:data];
}


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
