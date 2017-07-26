//
//  LNRefreshHandler.m
//  LNRefresh
//
//  Created by vvusu on 7/21/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNRefreshHandler.h"
#import "LNRefreshAnimator.h"
#import "LNFooterAnimator.h"

@implementation LNRefreshHandler

+ (LNRefreshHandler *)defaultHandler {
    static LNRefreshHandler *refreshHandler = nil;
    static dispatch_once_t onceQuoteHandler;
    dispatch_once(&onceQuoteHandler, ^{
        refreshHandler = [[LNRefreshHandler alloc]init];
        refreshHandler.headerType = -1;
        refreshHandler.stateImages = [NSMutableDictionary dictionary];
        refreshHandler.localizedStringDic = [LNRefreshHandler localizedStringDic];
    });
    return refreshHandler;
}

+ (NSDictionary *)localizedStringDic {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LNRefresh.bundle/lnrefresh" ofType:@"json"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    if (!fileData) { return @{};}
    NSError *error = nil;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:&error];
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *currentLanguage = languages.firstObject;
    NSDictionary *localizedStringDic = [jsonDic valueForKey:currentLanguage];
    if (!localizedStringDic) {
        localizedStringDic = [jsonDic valueForKey:@"en"];
    }
    return localizedStringDic;
}

+ (NSString *)localizedStringForKey:(NSString *)key {
   return [[LNRefreshHandler defaultHandler].localizedStringDic valueForKey:key];
}

+ (void)changeAllHeaderAnimatorType:(LNRefreshHeaderType)type {
    [LNRefreshHandler changeAllHeaderAnimatorType:type bgImage:nil];
}

+ (void)changeAllHeaderAnimatorType:(LNRefreshHeaderType)type bgImage:(UIImage *)image {
    [LNRefreshHandler changeAllHeaderAnimatorType:type bgImage:image incremental:0];
}

+ (void)changeAllHeaderAnimatorType:(LNRefreshHeaderType)type bgImage:(UIImage *)image incremental:(CGFloat)incremental {
    [LNRefreshHandler defaultHandler].bgImage = image;
    [LNRefreshHandler defaultHandler].headerType = type;
    [LNRefreshHandler defaultHandler].incremental = incremental;
    [[NSNotificationCenter defaultCenter] postNotificationName:LNRefreshChangeNotification object:nil];
}

+ (void)setAllHeaderAnimatorStateImages:(NSArray *)stateImages state:(LNRefreshState)state {
    [LNRefreshHandler setAllHeaderAnimatorStateImages:stateImages state:state duration:stateImages.count * 0.02];
}

+ (void)setAllHeaderAnimatorStateImages:(NSArray *)stateImages state:(LNRefreshState)state duration:(NSTimeInterval)duration {
    if (stateImages) {
        NSDictionary *dic = @{@"images":stateImages, @"duration":[NSNumber numberWithDouble:duration]};
        [[LNRefreshHandler defaultHandler].stateImages setValue:dic forKey:[NSString stringWithFormat:@"%ld",state]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LNRefreshChangeNotification object:nil];
}

@end
