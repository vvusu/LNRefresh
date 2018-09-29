//
//  LNHeaderTaobaoAnimator.m
//  LNRefresh
//
//  Created by vvusu on 8/25/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderTaobaoAnimator.h"

@interface LNHeaderTaobaoAnimator()
@property (nonatomic, strong) CAShapeLayer *arrowLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@end

@implementation LNHeaderTaobaoAnimator

+ (instancetype)createAnimator {
    LNHeaderTaobaoAnimator *diyAnimator = [[LNHeaderTaobaoAnimator alloc]init];
    diyAnimator.headerType = LNRefreshHeaderType_DIY;
    diyAnimator.trigger = 65;
    diyAnimator.incremental = 65;
    return diyAnimator;
}

- (CAShapeLayer *)arrowLayer {
    if (!_arrowLayer) {
        _arrowLayer = [[CAShapeLayer alloc]init];
        UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
        [bezierPath moveToPoint:CGPointMake(20, 15)];
        [bezierPath addLineToPoint:CGPointMake(20, 25)];
        [bezierPath addLineToPoint:CGPointMake(25, 20)];
        [bezierPath moveToPoint:CGPointMake(20, 25)];
        [bezierPath addLineToPoint:CGPointMake(15, 20)];
        _arrowLayer.lineWidth = 1.5;
        _arrowLayer.path = bezierPath.CGPath;
        _arrowLayer.lineCap = kCALineCapRound;
        _arrowLayer.fillColor = [UIColor clearColor].CGColor;
        _arrowLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _arrowLayer.bounds = CGRectMake(0, 0, 40, 40);
        _arrowLayer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _arrowLayer;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc]init];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20)
                                                                  radius:12.0
                                                              startAngle:-M_PI_2
                                                                endAngle:M_PI_2*3.0
                                                               clockwise:YES];
        _circleLayer.path = bezierPath.CGPath;
        _circleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.lineWidth = 1.0;
        _circleLayer.strokeEnd = 0.05;
        _circleLayer.strokeStart = 0.05;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.bounds = CGRectMake(0, 0, 40, 40);
        _circleLayer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _circleLayer;
}

- (void)setupHeaderView_DIY {
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"下拉即可刷新...";
    [self.animatorView addSubview:self.titleLabel];
    [self.animatorView.layer addSublayer:self.arrowLayer];
    [self.animatorView.layer addSublayer:self.circleLayer];
}

- (void)layoutHeaderView_DIY {
    CGRect react = self.animatorView.frame;
    self.arrowLayer.position = CGPointMake(react.size.width/2 - 40, react.size.height/2);
    self.circleLayer.position = CGPointMake(react.size.width/2 - 40, react.size.height/2);
    self.titleLabel.frame = CGRectMake((react.size.width - 100)/2 + 35, react.size.height/2 - 15, 100, 30);
}

- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
            [self endRefreshAnimation_DIY:view];
            break;
        case LNRefreshState_PullToRefresh:
            self.titleLabel.text = @"下拉即可刷新...";
            break;
        case LNRefreshState_WillRefresh:
            self.titleLabel.text = @"释放即可刷新...";
            break;
        case LNRefreshState_Refreshing:
            [self startRefreshAnimation_DIY:view];
            break;
        default:
            break;
    }
}

- (void)endRefreshAnimation_DIY:(LNRefreshComponent *)view {
    self.titleLabel.text = @"下拉即可刷新...";
    self.arrowLayer.hidden = NO;
    self.circleLayer.strokeEnd = 0.05;
    [self.circleLayer removeAllAnimations];
}

- (void)startRefreshAnimation_DIY:(LNRefreshComponent *)view {
    self.arrowLayer.hidden = YES;
    self.titleLabel.text = @"加载中...";
    self.circleLayer.strokeEnd = 0.95;
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.toValue = [[NSNumber alloc] initWithDouble:M_PI*2];
    rotateAnimation.duration = 0.6;
    rotateAnimation.cumulative = YES;
    rotateAnimation.repeatCount = 10000000;
    [self.circleLayer addAnimation:rotateAnimation forKey:@"rotate"];
}

- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {
    if (progress > 1.0) { return; }
    self.circleLayer.strokeEnd = 0.05 + 0.9 * progress;
}

@end
