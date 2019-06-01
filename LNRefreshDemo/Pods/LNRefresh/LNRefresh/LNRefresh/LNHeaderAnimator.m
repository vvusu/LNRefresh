//
//  LNHeaderAnimator.m
//  LNRefresh
//
//  Created by vvusu on 7/13/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderAnimator.h"
#import "LNRefreshHandler.h"

@interface LNHeaderAnimator()
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval arrowTime;
@property (nonatomic, strong) NSMutableDictionary *stateImages;       //所有状态对应的动画图片
@property (nonatomic, strong) NSMutableDictionary *stateDurations;    //所有状态对应的动画时间
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView; //UIActivityIndicatorView
@end

@implementation LNHeaderAnimator

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self == [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeHeaderAnimatorTyoe:)
                                                     name:LNRefreshChangeNotification object:nil];
    }
    return self;
}

- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        _stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations {
    if (!_stateDurations) {
        _stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text =  [LNRefreshHandler localizedStringForKey:LNRefreshPullToRefresh];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.image = [LNRefreshHandler bundleImage:@"refresh_arrow.png"];
    }
    return _imageView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_bgImageView setContentMode:UIViewContentModeScaleAspectFill];
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UIImageView *)gifView {
    if (!_gifView) {
        _gifView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _gifView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidden = YES;
    }
    return _indicatorView;
}

#pragma mark - Action

- (void)changeHeaderAnimatorTyoe:(NSNotification *)notification {
    if (!self.ignoreGlobSetting) {
        [self setupSubViews];
        if (self.state == LNRefreshState_Refreshing) {
            self.state = LNRefreshState_Normal;
            [self refreshView:nil state:LNRefreshState_Refreshing];
        }
    }
}

- (void)setupHeaderAnimator {
    if ([LNRefreshHandler defaultHandler].headerType >= 0) {
        self.headerType = [LNRefreshHandler defaultHandler].headerType;
        if (self.headerType == LNRefreshHeaderType_DIY) {
            [LNRefreshHandler defaultHandler].refreshTime = LNRefreshDIYRefreshTime;
        } else {
            [LNRefreshHandler defaultHandler].refreshTime = LNRefreshNORRefreshTime;
        }
    }
    if ([LNRefreshHandler defaultHandler].bgImage) {
        self.bgImageView.image = [LNRefreshHandler defaultHandler].bgImage;
    } else {
        self.bgImageView.image = nil;
    }
    if ([LNRefreshHandler defaultHandler].incremental > 0) {
        self.incremental = [LNRefreshHandler defaultHandler].incremental;
    }
    NSMutableDictionary *allStateImageDic = [LNRefreshHandler defaultHandler].stateImages;
    if (allStateImageDic.count > 0) {
        for (NSString *key in allStateImageDic.allKeys) {
            NSDictionary *dic = [allStateImageDic valueForKey:key];
            NSArray *images = [dic valueForKey:@"images"];
            NSNumber *duration = [dic valueForKey:@"duration"];
            [self setImages:images duration:duration.floatValue forState:(LNRefreshState)key.integerValue];
        }
    }
}

- (void)updateAnimationView {
    [super updateAnimationView];
}

- (void)changeHeaderType:(LNRefreshHeaderType)type {
    self.headerType = type;
    [self setupSubViews];
}

- (void)setupSubViews {
    [super setupSubViews];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.ignoreGlobSetting) {
            [self setupHeaderAnimator];
        }
        [self.animatorView addSubview:self.bgImageView];
        switch (self.headerType) {
            case LNRefreshHeaderType_NOR:
                [self setupSubViews_NOR];
                break;
            case LNRefreshHeaderType_GIF:
                [self setupSubViews_GIF];
                break;
            case LNRefreshHeaderType_DIY:
                [self setupHeaderView_DIY];
                break;
        }
        [self layoutSubviews];
    });
}

- (void)layoutSubviews {
    CGSize size = self.animatorView.bounds.size;
    CGFloat viewW = size.width;
    CGFloat bgImageH = self.bgImageView.image.size.height;
    CGFloat bgImageY = self.incremental < bgImageH ? self.incremental - bgImageH : 0;
    self.bgImageView.frame = CGRectMake(0, bgImageY, viewW, bgImageH);
    [UIView performWithoutAnimation:^{
        switch (self.headerType) {
            case LNRefreshHeaderType_NOR:
                [self layoutHeaderView_NOR];
                break;
            case LNRefreshHeaderType_GIF:
                [self layoutHeaderView_GIF];
                break;
            case LNRefreshHeaderType_DIY:
                [self layoutHeaderView_DIY];
                break;
        }
    }];
}

- (void)refreshView:(LNRefreshComponent *)view state:(LNRefreshState)state {
    if (self.state == state) { return; }
    self.state = state;
    switch (self.headerType) {
        case LNRefreshHeaderType_NOR: {
            switch (state) {
                case LNRefreshState_Normal:
                case LNRefreshState_PullToRefresh:
                    [self endRefreshAnimation_NOR];
                    break;
                case LNRefreshState_WillRefresh: {
                    self.titleLabel.text = [LNRefreshHandler localizedStringForKey:LNRefreshReleaseToRefresh];
                    [UIView animateWithDuration:0.2 animations:^{
                        self.arrowTime = 0.2;
                        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
                    }];
                }
                    break;
                case LNRefreshState_Refreshing:
                    [self startRefreshAnimation_NOR];
                    break;
                case LNRefreshState_NoMoreData:
                    self.titleLabel.text =  [LNRefreshHandler localizedStringForKey:LNRefreshNoMoreData];
                    break;
            }
        }
            break;
        case LNRefreshHeaderType_GIF: {
            switch (state) {
                case LNRefreshState_Normal:
                case LNRefreshState_PullToRefresh:
                    [self endRefreshAnimation_GIF:view];
                    break;
                case LNRefreshState_WillRefresh:
                case LNRefreshState_Refreshing:
                    [self startRefreshAnimation_GIF:state];
                    break;
                case LNRefreshState_NoMoreData:
                    self.gifView.hidden = YES;
                    break;
            }
        }
            break;
        case LNRefreshHeaderType_DIY:
            [self refreshHeaderView_DIY:view state:state];
            break;
    }
    [self layoutSubviews];
}

- (void)refreshView:(LNRefreshComponent *)view progress:(CGFloat)progress {
    [super refreshView:view progress:progress];
    switch (self.headerType) {
        case LNRefreshHeaderType_NOR:
            break;
        case LNRefreshHeaderType_GIF:
            [self refreshView_GIF:view progress:progress];
            break;
        case LNRefreshHeaderType_DIY:
            [self refreshView_DIY:view progress:progress];
            break;
    }
}

# pragma mark - NOR Action
- (void)setupSubViews_NOR {
    [self.animatorView addSubview:self.titleLabel];
    [self.animatorView addSubview:self.imageView];
    [self.animatorView addSubview:self.indicatorView];
}

- (void)layoutHeaderView_NOR {
    CGSize size = self.animatorView.bounds.size;
    CGFloat viewW = size.width;
    CGFloat viewH = size.height;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(viewW/2.0, viewH/2.0);
    self.indicatorView.center = CGPointMake(self.titleLabel.frame.origin.x - 16.0, viewH/2.0);
    self.imageView.frame = CGRectMake(0, 0, 18, 18);
    self.imageView.center = CGPointMake(self.titleLabel.frame.origin.x - 16.0, viewH/2.0);
}

- (void)startRefreshAnimation_NOR {
    [self.indicatorView startAnimating];
    self.imageView.hidden = YES;
    self.indicatorView.hidden = NO;
    self.titleLabel.text =  [LNRefreshHandler localizedStringForKey:LNRefreshLoading ];
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
}

- (void)endRefreshAnimation_NOR {
    [self.indicatorView stopAnimating];
    self.imageView.hidden = NO;
    self.indicatorView.hidden = YES;
    self.titleLabel.text =  [LNRefreshHandler localizedStringForKey:LNRefreshPullToRefresh];
    [UIView animateWithDuration:self.arrowTime animations:^{
        self.arrowTime = 0.0;
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

# pragma mark - GIF Action
- (void)setImages:(NSArray *)images forState:(LNRefreshState)state {
    [self setImages:images duration:images.count * 0.02 forState:state];
}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(LNRefreshState)state {
    if (images == nil) return;
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    UIImage *image = [images firstObject];
    if (image.size.height > self.incremental - 10) {
        self.incremental = image.size.height + 10;
    }
}

- (void)setupSubViews_GIF {
    [self.animatorView addSubview:self.gifView];
    [self endRefreshAnimation_GIF:nil];
}

- (void)layoutHeaderView_GIF {
    self.gifView.frame = self.animatorView.bounds;
    self.gifView.contentMode = UIViewContentModeCenter | UIViewContentModeBottom;
}

- (void)startRefreshAnimation_GIF:(LNRefreshState)state {
    NSArray *images = self.stateImages[@(state)];
    if (images.count == 0) return;
    self.gifView.hidden = NO;
    [self.gifView stopAnimating];
    if (images.count == 1) {
        self.gifView.image = [images lastObject];
    } else {
        self.gifView.animationImages = images;
        self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
        [self.gifView startAnimating];
    }
}

- (void)endRefreshAnimation_GIF:(LNRefreshComponent *)view {
    [self.gifView stopAnimating];
    if (self.stateImages.count > 0) {
        NSArray *images = self.stateImages[@(0)];
        self.gifView.image = images.firstObject;
    }
    [self refreshView:(LNRefreshComponent *)self.animatorView progress:0];
}

- (void)refreshView_GIF:(LNRefreshComponent *)view progress:(CGFloat)progress {
    NSArray *images = self.stateImages[@(LNRefreshState_Normal)];
    if (self.state != LNRefreshState_PullToRefresh || images.count == 0) return;
    [self.gifView stopAnimating];
    NSUInteger index = images.count * progress;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)gifViewReStartAnimation {
    [self.gifView startAnimating];
}

# pragma mark - DIY Action
- (void)setupHeaderView_DIY {}
- (void)layoutHeaderView_DIY {}
- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {}
- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {}
@end
