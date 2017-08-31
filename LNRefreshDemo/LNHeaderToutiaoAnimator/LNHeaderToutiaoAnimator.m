//
//  LNHeaderToutiaoAnimator.m
//  LNRefresh
//
//  Created by vvusu on 8/30/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderToutiaoAnimator.h"

static const CGFloat radius = 4.0;
static const CGFloat marginLR = 3.5;
static const CGFloat marginTB = 4.0;
static const CGFloat squareW = 7.0;
static const CGFloat squareH = 6.0;
static const CGFloat toutiaoW = 24.0;
static const CGFloat lineMargin = 2.0;

@interface LNHeaderToutiaoAnimator()
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) CGRect layerBReact;
@property (nonatomic, assign) CGRect layerCReact;
@property (nonatomic, assign) CGRect layerDReact;
@property (nonatomic, assign) CGRect layerEReact;
@property (nonatomic, assign) CGRect layerFReact;
@property (nonatomic, assign) CGRect layerGReact;
@property (nonatomic, strong) CAShapeLayer *layerA;       //外框
@property (nonatomic, strong) CAShapeLayer *layerB;       //矩形
@property (nonatomic, strong) CAShapeLayer *layerC;       //短Line
@property (nonatomic, strong) CAShapeLayer *layerD;       //长Line
@property (nonatomic, strong) CAShapeLayer *toutiaoLayer; //容器Layer
@end

@implementation LNHeaderToutiaoAnimator

+ (instancetype)createAnimator {
    LNHeaderToutiaoAnimator *diyAnimator = [[LNHeaderToutiaoAnimator alloc]init];
    diyAnimator.headerType = LNRefreshHeaderType_DIY;
    diyAnimator.trigger = 70;
    diyAnimator.incremental = 70;
    return diyAnimator;
}

- (CAShapeLayer *)createShapeLayer {
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.lineWidth = 1.0;
    layer.strokeEnd = 0;
    layer.strokeStart = 0;
    layer.fillColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00].CGColor;
    layer.strokeColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00].CGColor;
    return layer;
}

- (CAShapeLayer *)layerA {
    if (!_layerA) {
        _layerA = [self createShapeLayer];
        _layerA.lineWidth = 0.5;
        _layerA.frame = CGRectMake(0, 0, toutiaoW, toutiaoW);
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path moveToPoint:CGPointMake(toutiaoW - radius, 0)];
        [path addLineToPoint:CGPointMake(radius, 0)];
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
        [path addLineToPoint:CGPointMake(0,toutiaoW-radius)];
        [path addArcWithCenter:CGPointMake(radius, toutiaoW - radius) radius:radius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
        [path addLineToPoint:CGPointMake(toutiaoW-radius, toutiaoW)];
        [path addArcWithCenter:CGPointMake(toutiaoW - radius, toutiaoW - radius) radius:radius startAngle:M_PI_2 endAngle:0 clockwise:NO];
        [path addLineToPoint:CGPointMake(toutiaoW, radius)];
        [path addArcWithCenter:CGPointMake(toutiaoW - radius, radius) radius:radius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
        _layerA.path = path.CGPath;
    }
    return _layerA;
}

- (CAShapeLayer *)layerB {
    if (!_layerB) {
        _layerB = [self createShapeLayer];
        _layerB.lineWidth = 0.5;
        _layerB.fillColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.00].CGColor;
        self.layerBReact = CGRectMake(marginLR, marginTB, squareW, squareW);;
        _layerB.frame = self.layerBReact;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, squareW, squareH) cornerRadius:0];
        _layerB.path = path.CGPath;
    }
    return _layerB;
}

- (CAShapeLayer *)layerC {
    if (!_layerC) {
        _layerC = [self createShapeLayer];
        _layerC.masksToBounds = YES;
        self.layerCReact = CGRectMake(marginLR + squareW + 3, marginTB, squareW, squareW);
        _layerC.frame = self.layerCReact;
        UIBezierPath *path = [[UIBezierPath alloc]init];
        for (int i = 0; i < 3; i++) {
            [path moveToPoint:CGPointMake(0, 0.5+floor(i*(lineMargin + 1)))];
            [path addLineToPoint:CGPointMake(toutiaoW - marginLR*2, 0.5+floor(i*(lineMargin + 1)))];
        }
        _layerC.path = path.CGPath;
    }
    return _layerC;
}

- (CAShapeLayer *)layerD {
    if (!_layerD) {
        _layerD = [self createShapeLayer];
        _layerD.masksToBounds = YES;
        self.layerDReact = CGRectMake(marginLR, CGRectGetMaxY(self.layerCReact) + lineMargin, toutiaoW - marginLR*2, squareW);
        _layerD.frame = self.layerDReact;
        UIBezierPath *path = [[UIBezierPath alloc]init];
        for (int i = 0; i < 3; i++) {
            [path moveToPoint:CGPointMake(0, 0.5 + floor(i*(lineMargin + 1)))];
            [path addLineToPoint:CGPointMake(toutiaoW - marginLR*2, 0.5+floor(i*(lineMargin + 1)))];
        }
        _layerD.path = path.CGPath;
    }
    return _layerD;
}

- (CAShapeLayer *)toutiaoLayer {
    if (!_toutiaoLayer) {
        _toutiaoLayer = [CAShapeLayer new];
        _toutiaoLayer.frame = CGRectMake( 0, 0, toutiaoW, toutiaoW);
        [_toutiaoLayer addSublayer:self.layerA];
        [_toutiaoLayer addSublayer:self.layerB];
        [_toutiaoLayer addSublayer:self.layerC];
        [_toutiaoLayer addSublayer:self.layerD];
    }
    return _toutiaoLayer;
}

#pragma mark - Action

- (void)setupHeaderView_DIY {
    self.titleLabel.text = @"下拉推荐";
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.animatorView addSubview:self.titleLabel];
    [self.animatorView.layer addSublayer:self.toutiaoLayer];
}

- (void)layoutHeaderView_DIY {
    CGRect react = self.animatorView.frame;
    self.toutiaoLayer.frame = CGRectMake((react.size.width - toutiaoW)/2.0, (react.size.height - toutiaoW)/2.0, toutiaoW, toutiaoW);
    self.titleLabel.frame = CGRectMake(0,CGRectGetMaxY(self.toutiaoLayer.frame), react.size.width, 20);
    self.layerEReact = CGRectMake(self.layerCReact.origin.x,self.layerDReact.origin.y,self.layerCReact.size.width,squareW);
    self.layerFReact = CGRectMake(self.layerDReact.origin.x,self.layerDReact.origin.y,self.layerCReact.size.width,squareW);
    self.layerGReact = CGRectMake(self.layerBReact.origin.x,self.layerBReact.origin.y,self.layerDReact.size.width,squareW);
}

- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
            [self endRefreshAnimation_DIY:view];
            break;
        case LNRefreshState_PullToRefresh:
            break;
        case LNRefreshState_WillRefresh:
            self.titleLabel.text = @"松开推荐";
            break;
        case LNRefreshState_Refreshing:
            [self startRefreshAnimation_DIY:view];
            break;
        default:
            break;
    }
}

- (void)endRefreshAnimation_DIY:(LNRefreshComponent *)view {
    [self refreshView_DIY:view progress:0.0];
    [self setDefaultFrame];
    self.titleLabel.text = @"下拉推荐";
}

- (void)startRefreshAnimation_DIY:(LNRefreshComponent *)view {
    [self refreshView_DIY:view progress:1.0];
    [self setDefaultFrame];
    [self startLayerAnimation];
}

- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {
    if (progress > 1.0) { progress = 1.0; }
    self.layerA.strokeEnd = progress;
    self.layerB.strokeEnd = progress;
    self.layerC.strokeEnd = progress;
    self.layerD.strokeEnd = progress;
}

- (void)startLayerAnimation {
    // b - c - e - f /
    // c - d - f - g /
    // d - b - g - e /
    self.num = self.num%4;
    if (self.state != LNRefreshState_Refreshing) { return; }
    [UIView animateWithDuration:0.5 animations:^{
        switch (self.num) {
            case 0: {
                self.layerB.frame = self.layerBReact;
                self.layerC.frame = self.layerCReact;
                self.layerD.frame = self.layerDReact;
            }
                break;
            case 1: {
                self.layerB.frame = self.layerCReact;
                self.layerC.frame = self.layerDReact;
                self.layerD.frame = self.layerBReact;
            }
                break;
            case 2: {
                self.layerB.frame = self.layerEReact;
                self.layerC.frame = self.layerFReact;
                self.layerD.frame = self.layerGReact;
            }
                break;
            case 3: {
                self.layerB.frame = self.layerFReact;
                self.layerC.frame = self.layerGReact;
                self.layerD.frame = self.layerEReact;
            }
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        if (finished) {
            self.num++;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startLayerAnimation];
            });
        }
    }];
}

- (void)setDefaultFrame {
    self.num = 0;
    self.layerB.frame = self.layerBReact;
    self.layerC.frame = self.layerCReact;
    self.layerD.frame = self.layerDReact;
}

@end
