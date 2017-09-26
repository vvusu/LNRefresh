//
//  LNFooterAnimator.m
//  LNRefresh
//
//  Created by vvusu on 7/13/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNFooterAnimator.h"
#import "LNRefreshHandler.h"

@interface LNFooterAnimator()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation LNFooterAnimator

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = LNRefreshLabelFont;
        _titleLabel.textColor = LNRefreshLabelTextColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = [LNRefreshHandler localizedStringForKey:LNRefreshLoadingMore];
    }
    return _titleLabel;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidden = YES;
    }
    return _indicatorView;
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.animatorView addSubview:self.titleLabel];
    [self.animatorView addSubview:self.indicatorView];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    CGSize size = self.animatorView.bounds.size;
    CGFloat viewW = size.width;
    CGFloat viewH = size.height;
    [UIView performWithoutAnimation:^{
        [self.titleLabel sizeToFit];
        self.titleLabel.center = CGPointMake(viewW/2.0, viewH/2.0);
        self.indicatorView.center = CGPointMake(self.titleLabel.frame.origin.x - 16.0, viewH/2.0);
    }];
}

- (void)refreshView:(LNRefreshComponent *)view state:(LNRefreshState)state {
    if (self.state == state) { return; }
    self.state = state;
    switch (state) {
        case LNRefreshState_Normal: {
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            self.titleLabel.text = [LNRefreshHandler localizedStringForKey:LNRefreshLoadingMore];
        }
            break;
        case LNRefreshState_Refreshing: {
            [self.indicatorView startAnimating];
            self.indicatorView.hidden = NO;
            self.titleLabel.text = [LNRefreshHandler localizedStringForKey:LNRefreshLoading];
        }
            break;
        case LNRefreshState_NoMoreData:
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            self.titleLabel.text = [LNRefreshHandler localizedStringForKey:LNRefreshNoMoreData];
            break;
        default:
            break;
    }
    [self layoutSubviews];
}

@end
