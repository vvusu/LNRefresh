//
//  DemoVC.h
//  LNRefresh
//
//  Created by vvusu on 7/17/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LNDemoVCType) {
    LNDemoVCType_TableView = 0,
    LNDemoVCType_CollectionView,
    LNDemoVCType_WebView,
    LNDemoVCType_TextView
};

typedef NS_ENUM(NSInteger, LNDemoDIYType) {
    LNDemoDIYType_NOR = 0,
    LNDemoDIYType_DJ,
    LNDemoDIYType_TMall,
    LNDemoDIYType_TaoBao,
    LNDemoDIYType_KaoLa,
    LNDemoDIYType_Meituan,
    LNDemoDIYType_NetEaseNews,
    LNDemoDIYType_Toutiao,
    LNDemoDIYType_Feizhu,
    LNDemoDIYType_ELE
};

@interface DemoVC : UIViewController
@property (nonatomic, assign) BOOL isGIF;
@property (nonatomic, assign) BOOL isDIY;
@property (nonatomic, assign) LNDemoVCType vcType;
@property (nonatomic, assign) LNDemoDIYType DIYType;

@end
