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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *gifView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, assign) LNRefreshHeaderType headerType;

- (void)gifViewReStartAnimation;
- (void)changeHeaderType:(LNRefreshHeaderType)type;
- (void)setImages:(NSArray *)images forState:(LNRefreshState)state;
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(LNRefreshState)state;

- (void)setupHeaderView_DIY;
- (void)layoutHeaderView_DIY;
- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress;
- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state;
@end
