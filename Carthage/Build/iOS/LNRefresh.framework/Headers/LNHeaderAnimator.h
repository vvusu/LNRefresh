//
//  LNHeaderAnimator.h
//  LNRefresh
//
//  Created by vvusu on 7/13/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNRefreshAnimator.h"

typedef NS_ENUM(NSInteger, LNRefreshHeaderType) {
    LNRefreshHeaderType_NOR = 0,
    LNRefreshHeaderType_GIF,
    LNRefreshHeaderType_DIY
};

@interface LNHeaderAnimator : LNRefreshAnimator
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, assign) LNRefreshHeaderType headerType;

- (void)changeHeaderType:(LNRefreshHeaderType)type;
- (void)setImages:(NSArray *)images forState:(LNRefreshState)state;
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(LNRefreshState)state;

@end
