//
//  LNHeaderAnimator+Analysis.m
//  LNRefresh
//
//  Created by vvusu on 7/20/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderAnimator+Analysis.h"

@implementation LNHeaderAnimator (Analysis)

+ (void)load {
    [self exchangeInstanceMethod1:@selector(refreshView:state:) method2:@selector(ln_refreshView:state:)];
}

- (void)ln_refreshView:(LNRefreshComponent *)view state:(LNRefreshState)state {
    [self ln_refreshView:view state:state];
    if (state == LNRefreshState_Refreshing) {
        // 处理打点统计相关代码
        NSLog(@"LN______打点");
    }
}

@end
