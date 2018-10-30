//
//  JZInfiniteCustomCellProtocol.h
//  InfiniteScrollView
//
//  Created by Allen on 2018/10/30.
//  Copyright © 2018年 daojia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 自定义cell需要遵守这个Protocol
 */
@protocol JZInfiniteCustomCellProtocol <NSObject>

@required
- (void)setupCellWithData:(id)data atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
