//
//  LNHeaderJDAnimator.m
//  LNRefresh
//
//  Created by vvusu on 8/24/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderJDAnimator.h"

@interface LNHeaderJDAnimator()
@property (nonatomic, assign) CGRect GifView1Rect;
@property (nonatomic, assign) CGRect GifView2Rect;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *gifView1;
@property (nonatomic, strong) UIImageView *gifView2;
@property (nonatomic, strong) UIImageView *gifView3;
@end

@implementation LNHeaderJDAnimator

+ (instancetype)createAnimator {
    LNHeaderJDAnimator *diyAnimator = [[LNHeaderJDAnimator alloc]init];
    diyAnimator.headerType = LNRefreshHeaderType_DIY;
    diyAnimator.trigger = 85;
    diyAnimator.incremental = 85;
    return diyAnimator;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = @"让购物更便捷";
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UIImageView *)gifView1 {
    if (!_gifView1) {
        _gifView1 = [[UIImageView alloc]init];
        _gifView1.image = [UIImage imageNamed:@"app_refresh_goods_0"];
    }
    return _gifView1;
}

- (UIImageView *)gifView2 {
    if (!_gifView2) {
        _gifView2 = [[UIImageView alloc]init];
        _gifView2.image = [UIImage imageNamed:@"app_refresh_people_0"];
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"app_refresh_people_%zd", i]];
            [idleImages addObject:image];
        }
        _gifView2.animationImages = idleImages;
        _gifView2.animationDuration = 0.3;
    }
    return _gifView2;
}

- (UIImageView *)gifView3 {
    if (!_gifView3) {
        _gifView3 = [[UIImageView alloc]init];
        _gifView3.image = [UIImage imageNamed:@"app_refresh_speed"];
        _gifView3.hidden = YES;
    }
    return _gifView3;
}

- (void)setupHeaderView_DIY {
    [self.animatorView addSubview:self.contentLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.text = @"下拉更新...";
    [self.animatorView addSubview:self.titleLabel];
    [self.animatorView addSubview:self.gifView1];
    [self.animatorView addSubview:self.gifView2];
    [self.animatorView addSubview:self.gifView3];
}

- (void)layoutHeaderView_DIY {
    if (self.state == LNRefreshState_Normal) {
        CGRect react = self.animatorView.frame;
        CGFloat labelX = (react.size.width - 100)/2 + 25;
        CGFloat labelY = react.size.height - 60;
        self.contentLabel.frame = CGRectMake(labelX, labelY, 100, 20);
        self.titleLabel.frame = CGRectMake(labelX, labelY + 20, 100, 20);
        self.GifView1Rect = CGRectMake(labelX, labelY + 20, 0, 0);
        self.gifView1.frame = self.GifView1Rect;
        self.GifView2Rect = CGRectMake(labelX - 100, react.size.height, 0, 0);
        self.gifView2.frame = self.GifView2Rect;
        self.gifView3.frame = CGRectMake(labelX - 105, labelY + 10, 41, 33);
    }
}

- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
        case LNRefreshState_PullToRefresh:
            [self endRefreshAnimation_DIY:view];
            break;
        case LNRefreshState_WillRefresh:
            [self startRefreshAnimation_DIY:view];
            self.titleLabel.text = @"松手更新...";
            break;
        case LNRefreshState_Refreshing:
            [self startRefreshAnimation_DIY:view];
            break;
        default:
            break;
    }
}

- (void)endRefreshAnimation_DIY:(LNRefreshComponent *)view {
    self.titleLabel.text = @"下拉更新...";
    self.gifView1.frame = self.GifView1Rect;
    self.gifView2.frame = self.GifView2Rect;
    [self.gifView2 stopAnimating];
    self.gifView1.hidden = NO;
    self.gifView3.hidden = YES;
}

- (void)startRefreshAnimation_DIY:(LNRefreshComponent *)view {
    [self refreshView_DIY:nil progress:1];
    self.titleLabel.text = @"更新中...";
    self.gifView1.hidden = YES;
    self.gifView3.hidden = NO;
    [self.gifView2 startAnimating];
}

- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {
    if (progress > 1.0) { return; }
    self.gifView1.frame = CGRectMake(self.GifView1Rect.origin.x - 36.0*progress,
                                     self.GifView1Rect.origin.y - 5.0*progress,
                                     self.GifView1Rect.size.width + 20.0*progress,
                                     self.GifView1Rect.size.height + 15.0*progress);
    
    self.gifView2.frame = CGRectMake(self.GifView2Rect.origin.x + 30.0*progress,
                                     self.GifView2Rect.origin.y - 78.0*progress,
                                     self.GifView2Rect.size.width + 53.0*progress,
                                     self.GifView2Rect.size.height + 73.0*progress);
}

@end
