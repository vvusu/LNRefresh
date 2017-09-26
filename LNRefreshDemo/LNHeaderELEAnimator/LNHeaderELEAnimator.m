//
//  LNHeaderELEAnimator.m
//  LNRefresh
//
//  Created by vvusu on 9/5/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderELEAnimator.h"

static const CGFloat eleW = 28.0;
static const CGFloat lineW = 4.0;
static const CGFloat radius = 14;
static const CGFloat eleAngle = 35.0;
static const CGFloat elePointW = 5.0;
static const CGFloat eleLodingW = 44.0;
static const CGFloat eleLodingPointerW = 8.0;
static const CGFloat eleLodingPointerH = 14.0;

#define KELEBlueColor [UIColor colorWithRed:0 green:170/255.0 blue:1 alpha:1.00]

@interface LNHeaderELEAnimator()
@property (nonatomic, strong) UIView *eleLogoView;
@property (nonatomic, assign) CGPoint pointLayerCG;
@property (nonatomic, strong) CAShapeLayer *eleLayer;
@property (nonatomic, strong) CAShapeLayer *pointLayer;
@property (nonatomic, strong) UIView *eleLoadingView;
@property (nonatomic, strong) CAShapeLayer *arcLayerA;
@property (nonatomic, strong) CAShapeLayer *arcLayerB;
@property (nonatomic, strong) CAShapeLayer *arcLayerC;
@property (nonatomic, strong) CAShapeLayer *pointerLayerA;
@property (nonatomic, strong) CAShapeLayer *pointerLayerB;
@end

@implementation LNHeaderELEAnimator

+ (instancetype)createAnimator {
    LNHeaderELEAnimator *diyAnimator = [[LNHeaderELEAnimator alloc]init];
    diyAnimator.headerType = LNRefreshHeaderType_DIY;
    diyAnimator.trigger = 88;
    diyAnimator.incremental = 88;
    return diyAnimator;
}

- (CAShapeLayer *)eleLayer {
    if (!_eleLayer) {
        _eleLayer = [CAShapeLayer new];
        _eleLayer.lineWidth = lineW;
        _eleLayer.strokeEnd = 0;
        _eleLayer.strokeStart = 0;
        _eleLayer.lineCap = kCALineCapRound;
        _eleLayer.fillColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00].CGColor;
        _eleLayer.strokeColor = KELEBlueColor.CGColor;
        UIBezierPath *path = [[UIBezierPath alloc]init];
        path.lineCapStyle = kCGLineCapRound;
        [path moveToPoint:CGPointMake(radius-1, radius+1)];
        [path addLineToPoint:CGPointMake(radius + radius*cos(-eleAngle*M_PI/180), radius + radius*sin(-eleAngle*M_PI/180))];
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius - lineW + 2 startAngle:-eleAngle*M_PI/180 endAngle:M_PI/3 clockwise:NO];
        _eleLayer.path = path.CGPath;
    }
    return _eleLayer;
}

- (CAShapeLayer *)pointLayer {
    if (!_pointLayer) {
        _pointLayer = [CAShapeLayer new];
        _pointLayer.lineWidth = 1.f;
        _pointLayer.masksToBounds = YES;
        _pointLayer.fillColor = KELEBlueColor.CGColor;
        _pointLayer.strokeColor = KELEBlueColor.CGColor;
        self.pointLayerCG = CGPointMake(eleW/2, eleW);
        _pointLayer.frame = CGRectMake(eleW/2, eleW, elePointW, elePointW);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, elePointW, elePointW)
                                                   byRoundingCorners:UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(2, 2)];
        _pointLayer.path = path.CGPath;
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformRotate(transform, -40*M_PI/180.0);
        _pointLayer.affineTransform = transform;
    }
    return _pointLayer;
}

- (UIView *)eleLogoView {
    if (!_eleLogoView) {
        _eleLogoView = [[UIView alloc]init];
        _eleLogoView.frame = CGRectMake(0, 0, eleW, eleW);
        self.eleLayer.frame = _eleLayer.bounds;
        [_eleLogoView.layer addSublayer:self.eleLayer];
        [_eleLogoView.layer addSublayer:self.pointLayer];
    }
    return _eleLogoView;
}

- (CAShapeLayer *)arcLayerA {
    if (!_arcLayerA) {
        _arcLayerA = [CAShapeLayer new];
    }
    return _arcLayerA;
}

- (CAShapeLayer *)arcLayerB {
    if (!_arcLayerB) {
        _arcLayerB = [CAShapeLayer new];
    }
    return _arcLayerB;
}

- (CAShapeLayer *)arcLayerC {
    if (!_arcLayerC) {
        _arcLayerC = [CAShapeLayer new];
    }
    return _arcLayerC;
}

- (CAShapeLayer *)pointerLayerA {
    if (!_pointerLayerA) {
        _pointerLayerA = [CAShapeLayer new];
        _pointerLayerA.lineWidth = 2.f;
        _pointerLayerA.lineCap = kCALineCapRound;
        _pointerLayerA.fillColor = KELEBlueColor.CGColor;
        _pointerLayerA.strokeColor = KELEBlueColor.CGColor;
        _pointerLayerA.frame = CGRectMake(eleLodingW/2 - eleLodingPointerW/2, 0, eleLodingPointerW, eleLodingPointerH);
        _pointerLayerA.position = CGPointMake(eleLodingW/2, eleLodingW/2);
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path moveToPoint:CGPointMake(eleLodingPointerW/2, 1)];
        [path addLineToPoint:CGPointMake(eleLodingPointerW/2, eleLodingPointerH/2)];
        _pointerLayerA.path = path.CGPath;
    }
    return _pointerLayerA;
}

- (CAShapeLayer *)pointerLayerB {
    if (!_pointerLayerB) {
        _pointerLayerB = [CAShapeLayer new];
        _pointerLayerB.lineWidth = 2.f;
        _pointerLayerB.lineCap = kCALineCapRound;
        _pointerLayerB.fillColor = KELEBlueColor.CGColor;
        _pointerLayerB.strokeColor = KELEBlueColor.CGColor;
        _pointerLayerB.frame = CGRectMake(eleLodingW/2 - eleLodingPointerW/2, eleLodingPointerH, eleLodingPointerW, eleLodingPointerH);
        _pointerLayerB.position = CGPointMake(eleLodingW/2, eleLodingW/2);
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path moveToPoint:CGPointMake(eleLodingPointerW/2, eleLodingPointerH/2)];
        [path addLineToPoint:CGPointMake(eleLodingPointerW/2, eleLodingPointerH)];
        _pointerLayerB.path = path.CGPath;
    }
    return _pointerLayerB;
}

- (UIView *)eleLoadingView {
    if (!_eleLoadingView) {
        _eleLoadingView = [[UIView alloc]init];
        _eleLoadingView.frame = CGRectMake(0, 0, eleLodingW, eleLodingW);
        [_eleLoadingView.layer addSublayer:self.arcLayerA];
        [_eleLoadingView.layer addSublayer:self.arcLayerB];
        [_eleLoadingView.layer addSublayer:self.arcLayerC];
        [_eleLoadingView.layer addSublayer:self.pointerLayerA];
        [_eleLoadingView.layer addSublayer:self.pointerLayerB];
//        _eleLodingView.backgroundColor = [UIColor redColor];
    }
    return _eleLoadingView;
}

#pragma mark - Action

- (void)setupHeaderView_DIY {
    [self.animatorView addSubview:self.eleLoadingView];
    [self.animatorView addSubview:self.eleLogoView];
}

- (void)layoutHeaderView_DIY {
    CGRect react = self.animatorView.frame;
    self.eleLogoView.center = CGPointMake(react.size.width/2, react.size.height/2);
    self.eleLoadingView.center = CGPointMake(react.size.width/2, react.size.height/2);
}

- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
            [self endRefreshAnimation_DIY:view];
            break;
        case LNRefreshState_PullToRefresh:
            break;
        case LNRefreshState_WillRefresh:
            break;
        case LNRefreshState_Refreshing:
            [self startRefreshAnimation_DIY:view];
            break;
        default:
            break;
    }
}

- (void)endRefreshAnimation_DIY:(LNRefreshComponent *)view {
    [self refreshView_DIY:view progress:0.75];
    [self refreshView_DIY:view progress:0.0];
    [self stopLodingAnimation];
}

- (void)startRefreshAnimation_DIY:(LNRefreshComponent *)view {
    [self refreshView_DIY:view progress:1.0];
    [self startLodingAnimation];
}

- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {
    //ele
    if (progress > 1.0) { progress = 1.0; }
    self.eleLayer.strokeEnd = progress;
    //point
    CGFloat num = 4;
    CGFloat pointNum = 1/num;
    if (progress >= (num - 1)*pointNum) {
        progress -= (num - 1)*pointNum;
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformScale(transform, progress * num, progress * num);
        transform = CGAffineTransformRotate(transform, -30*M_PI/180.0);
        self.pointLayer.affineTransform = transform;
        self.pointLayer.position = CGPointMake(self.pointLayerCG.x + (eleW/2 - elePointW/2) * progress * num,
                                               self.pointLayerCG.y - (eleW/2 - elePointW/2) * progress * num);
    }
}

- (void)startLodingAnimation {
    //ele logo view
    [UIView animateWithDuration:0.6 animations:^{
        self.eleLogoView.alpha = 0;
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformScale(transform, 0.5, 0.5);
        self.eleLogoView.transform = transform;
    }];
    
    //ele loading view
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    circleAnimation.duration = 2.0f;
    circleAnimation.repeatCount = MAXFLOAT;
    circleAnimation.toValue = @(M_PI*2);
    [self.pointerLayerA addAnimation:circleAnimation forKey:@"rotation"];
    
    CABasicAnimation *circleBAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    circleBAnimation.duration = 0.5f;
    circleBAnimation.repeatCount = MAXFLOAT;
    circleBAnimation.toValue = @(M_PI*2);
    [self.pointerLayerB addAnimation:circleBAnimation forKey:@"rotation"];
}

- (void)stopLodingAnimation {
    [self.pointerLayerA removeAllAnimations];
    [self.pointerLayerB removeAllAnimations];
    self.eleLogoView.alpha = 1.0;
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1, 1);
    self.eleLogoView.transform = transform;
}

@end
