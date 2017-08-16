//
//  YLoadingPanel.m
//  MVendorFramework
//
//  Created by wscn on 16/12/3.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import "YLoadingPanel.h"

@interface YLoadingPanel()<CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray *circlesArr;
@property (nonatomic, assign) BOOL isPageLoading;

@end

@implementation YLoadingPanel

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}


- (void)setupDefaults
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.circlesArr = [NSMutableArray array];
    self.refreshHeader = 65.0;
    self.internalSpacing = 5;
    self.radius = 5;
    self.delay = 0.2;
    self.duration = 0.5;
    self.defaultColor = [UIColor colorWithRed:110.0f/225.0f green:148.0f/225.0f blue:212.0f/225.0f alpha:1.0];
    self.maxCirclesNumber = 3;
}

- (void)addACircle
{
    if (self.circlesArr.count + 1 > _maxCirclesNumber) {
        return;
    }
    UIView *aCircle = [self createCircleWithRadius:self.radius color:_defaultColor positionX:(self.circlesArr.count * ((2 * self.radius) + self.internalSpacing))];
    [self addSubview:aCircle];
    aCircle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    //    CGFloat f = self.circlesArr.count/_maxCirclesNumber;
    [self.circlesArr addObject:aCircle];
    if (self.isPageLoading) {
        [UIView animateWithDuration:.3 animations:^{
            aCircle.frame = CGRectMake((self.circlesArr.count * ((2 * self.radius) + self.internalSpacing)), 0, self.radius * 2, self.radius * 2);
            if (self.circlesArr.count == 2) {
                aCircle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
            } else if (self.circlesArr.count == 3) {
                aCircle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
            }
            
        } completion:^(BOOL finished) {
           [self adjustFrame];
        }];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            aCircle.frame = CGRectMake((self.circlesArr.count * ((2 * self.radius) + self.internalSpacing)), 0, self.radius * 2, self.radius * 2);
            if (self.circlesArr.count == 2) {
                aCircle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
            } else if (self.circlesArr.count == 3) {
                aCircle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
            }
            [self adjustFrame];
        }];
    }
    
}

- (void)removeACircle
{
    if (self.circlesArr.count > 0) {
        UIView *circle = self.circlesArr.lastObject;
        [self.circlesArr removeObject:circle];
        
        [UIView animateWithDuration:.3 animations:^{
            CGRect rect = circle.frame;
            rect.origin.y = -75;
            circle.frame = rect;
        } completion:^(BOOL finished) {
            [circle removeFromSuperview];
        }];
    }
}

- (void)removeAllCircles
{
    if (self.circlesArr.count > 0) {
        for (int i = 0; i <self.circlesArr.count; i++) {
            [self removeACircle];
        }
    }
}

- (UIView *)createCircleWithRadius:(CGFloat)radius
                             color:(UIColor *)color
                         positionX:(CGFloat)x
{
    radius = radius;
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(x, -90, radius * 2, radius * 2)];
    circle.backgroundColor = color;
    circle.layer.cornerRadius = radius;
    circle.translatesAutoresizingMaskIntoConstraints = NO;
    return circle;
}

- (CABasicAnimation *)createSigleAnimationWithDuration:(CGFloat)duration withIndex:(int)index
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.fromValue = [NSNumber numberWithFloat:1.f];
    anim.toValue = [NSNumber numberWithFloat:index/_maxCirclesNumber];
    anim.duration = duration;
    anim.removedOnCompletion = YES;
    anim.beginTime = CACurrentMediaTime();
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fillMode = kCAFillModeBoth;
    return anim;
}

- (CABasicAnimation *)createAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.delegate = self;
    anim.fromValue = [NSNumber numberWithFloat:0.0f];
    anim.toValue = [NSNumber numberWithFloat:1.0f];
    anim.autoreverses = YES;
    anim.duration = duration;
    anim.removedOnCompletion = NO;
    anim.beginTime = CACurrentMediaTime()+delay;
    anim.repeatCount = INFINITY;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fillMode = kCAFillModeBoth;
    return anim;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.isCircleAnimation = flag;
}

- (void)animationDidStart:(CAAnimation *)anim {
    self.isCircleAnimation = YES;

}

//开始动画
- (void)doAnimation
{
    for (int i = 0; i < self.circlesArr.count; i++) {
        UIView *circle = self.circlesArr[i];
        [circle.layer removeAllAnimations];
        [circle.layer addAnimation:[self createAnimationWithDuration:self.duration delay:(i * self.delay)] forKey:@"scale"];
    }
}

//结束动画
- (void)stopAnimation
{
    for (int i = 0; i < self.circlesArr.count; i++) {
        UIView *circle = self.circlesArr[i];
        [circle.layer removeAllAnimations];
    }
}

- (void)keepNumber:(int)number
{
    if (number == 0 || number < 0) {
        for (int i = 0; i < self.circlesArr.count; i++) {
            UIView *circle = self.circlesArr[i];
            [circle removeFromSuperview];
        }
        [self.circlesArr removeAllObjects];
        return;
    }
    else if (self.circlesArr.count < number) {
        for (int i = (int)self.circlesArr.count; i < number; i++) {
            [self addACircle];
        }
    }
    else if (self.circlesArr.count > number) {
        for (int i = number; i < self.circlesArr.count; i++) {
            [self removeACircle];
        }
    }
}

- (void)setOffsetY:(CGFloat)offsetY
{
    _offsetY = offsetY;
    self.isPageLoading = NO;
    float per = self.refreshHeader / _maxCirclesNumber;
    if (_offsetY < per) {
        
        [self keepNumber:1];
    }
    else if (_offsetY < per*2) {
        
        [self keepNumber:2];
    }
    else if(_offsetY < per*3) {
        
        [self keepNumber:3];
    }
}

-(void)setPullingPercent:(CGFloat)pullingPercent {
    _pullingPercent = pullingPercent;
    self.isPageLoading = NO;
    if (pullingPercent > 0.1 && pullingPercent <= 0.5) {
        [self keepNumber:1];
    } else if (pullingPercent > 0.5 && pullingPercent < 0.8) {
        [self keepNumber:2];
        
    } else {
        [self keepNumber:3];
        
    }
}


- (void)adjustFrame
{
    CGRect frame = self.bounds;
    frame.size.width = (self.circlesArr.count * ((2 * self.radius) + self.internalSpacing)) - self.internalSpacing;
    frame.size.height = self.radius * 2;
    self.bounds = frame;
    for (int i = 0; i < self.circlesArr.count; i++) {
        UIView *circle = self.circlesArr[i];
        CGRect rect = circle.frame;
        rect.origin.x = (i * ((2 * self.radius) + self.internalSpacing));
        circle.frame = rect;
    }
}

- (void)setDefaultColor:(UIColor *)defaultColor
{
    _defaultColor = defaultColor;
    for (int i = 0; i < self.circlesArr.count; i++) {
        UIView *circle = self.circlesArr[i];
        [circle setBackgroundColor:defaultColor];
    }
}

-(void)setRefreshHeader:(CGFloat)refreshHeader {
    _refreshHeader = refreshHeader;
}

- (void)doAutoPullDown
{
    float per = self.refreshHeader  / _maxCirclesNumber;
    self.offsetY = 3*per - 1;
}

- (void)doAutoPullDownWithPullingPercent
{
    self.pullingPercent = 0.9;
}


//开始页面加载动画
- (void)doPageLoadingAnimation
{
    self.isPageLoading = YES;
    [self stopPageLoadingAnimation];
    //添加3个点
    [self keepNumber:3];
    [self doAnimation];
}

- (void)stopPageLoadingAnimation
{
    [self stopAnimation];
    
    for (UIView *circle in self.circlesArr) {
        [circle removeFromSuperview];
    }
    [self.circlesArr removeAllObjects];
    
}

@end
