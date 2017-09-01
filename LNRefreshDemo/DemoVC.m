//
//  DemoVC.m
//  LNRefresh
//
//  Created by vvusu on 7/17/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "DemoVC.h"
#import <LNRefresh/LNRefresh.h>
#import "LNHeaderDIYAnimator.h"
#import "LNHeaderJDAnimator.h"
#import "LNHeaderTmallAnimator.h"
#import "LNHeaderTaobaoAnimator.h"
#import "LNHeaderMeituanAnimator.h"
#import "LNHeaderKaolaAnimator.h"
#import "LNHeaderNetEaseNewsAnimator.h"
#import "LNHeaderToutiaoAnimator.h"
#import "LNHeaderFeizhuAnimator.h"

#define LNViewW self.view.frame.size.width
#define LNViewH self.view.frame.size.height - 64
#define LNViewBGColor [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00]

@interface DemoVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIButton *changeBtn;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation DemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArr = [NSMutableArray array];
    switch (self.vcType) {
        case LNDemoVCType_TableView:
            self.navigationItem.title = @"UITableView";
            [self createTableView];
            [self.view addSubview:self.changeBtn];
            break;
        case LNDemoVCType_CollectionView:
            self.navigationItem.title = @"UICollectionView";
            [self createCollectionView];
            [self.view addSubview:self.changeBtn];
            break;
        case LNDemoVCType_WebView:
            self.navigationItem.title = @"UIWebView";
            [self createWebView];
            break;
        case LNDemoVCType_TextView:
            self.navigationItem.title = @"UITextView";
            [self createTextView];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _changeBtn.frame = CGRectMake(0, LNViewH,LNViewW, 40);
        [_changeBtn setTitle:@"Change Animator" forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_changeBtn addTarget:self action:@selector(changeLNRefreshHeaderAnimationType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

//全局改变下拉配置Type
- (void)changeLNRefreshHeaderAnimationType:(UIButton *)btn {
    self.changeBtn.selected = !btn.selected;
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=27; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%zd", i]];
        [idleImages addObject:image];
    }
    [LNRefreshHandler setAllHeaderAnimatorStateImages:idleImages state:LNRefreshState_Normal];
    [LNRefreshHandler setAllHeaderAnimatorStateImages:idleImages state:LNRefreshState_Refreshing];
    if (!self.changeBtn.selected) {
        [LNRefreshHandler changeAllHeaderAnimatorType:LNRefreshHeaderType_DIY
                                              bgImage:[UIImage imageNamed:@"refresh_bgimage_1.jpg"] incremental:100];
    } else {
        [LNRefreshHandler changeAllHeaderAnimatorType:LNRefreshHeaderType_GIF bgImage:nil incremental:50];
    }
}

- (NSString *)randomUnicodeString {
    NSString *icon = @"🐶🐱🐼🐷🐮🐽🐸🐙🐵🐤🐦🐣🦅🦉🐺🐗🦋🐛🦄🐴🍏🍐🍊🍋🍇🍓🍒🍑🍍🥝🥑🍅🍆🥒🥕🌽🍠🥜";
    NSInteger num = arc4random_uniform((int)icon.length - 2);
    num = num%2 == 0 ? num : num - 1;
    return [icon substringWithRange:NSMakeRange(num, 2)];
}

- (void)pullToRefresh {
    NSLog(@"下拉刷新");
    [self.dataArr removeAllObjects];
    for (NSInteger i = 0; i < 10; i++) {
        [self.dataArr addObject:[self randomUnicodeString]];
    }
    __weak UITableView *wtableView = self.tableView;
    __weak UICollectionView *wcollectionView = self.collectionView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        num = 0;
        if (self.vcType == LNDemoVCType_TableView) {
            [wtableView reloadData];
            [wtableView endRefreshing];
            [wtableView pullDownDealFooterWithItemCount:self.dataArr.count cursor:@"11"];
        }
        if (self.vcType == LNDemoVCType_CollectionView) {
            [wcollectionView reloadData];
            [wcollectionView endRefreshing];
        }
    });
}

static NSUInteger num = 0;
- (void)loadMoreRefresh {
    NSLog(@"上拉加载更多");
    for (NSInteger i = 0; i < 1; i++) {
        [self.dataArr addObject:[self randomUnicodeString]];
    }
    __weak UITableView *wtableView = self.tableView;
    __weak UICollectionView *wcollectionView = self.collectionView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (num > 2) {
            if (self.vcType == LNDemoVCType_TableView) {
                [wtableView noticeNoMoreData];
            }
            if (self.vcType == LNDemoVCType_CollectionView) {
                [wcollectionView noticeNoMoreData];
            }
            return;
        }
        num++;
        if (self.vcType == LNDemoVCType_TableView) {
            [wtableView reloadData];
            [wtableView endLoadingMore];
        }
        if (self.vcType == LNDemoVCType_CollectionView) {
            [wcollectionView reloadData];
            [wcollectionView endLoadingMore];
        }
    });
}

#pragma mark - UITableView datasource and delegate

- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, LNViewW, LNViewH) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableVCCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = LNViewBGColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    __weak typeof(self) wself = self;
    // 默认刷新动画
    if (!self.isDIY) {
        [self.tableView addPullToRefresh:^{
            [wself pullToRefresh];
        }];
        [self.tableView addInfiniteScrolling:^{
            [wself loadMoreRefresh];
        }];
        LNHeaderAnimator *haderAnimator = (LNHeaderAnimator *)self.tableView.ln_header.animator;
        haderAnimator.bgImageView.image = [UIImage imageNamed:@"refresh_bgimage_1.jpg"];
        //自定义下拉高度
        //self.tableView.ln_header.animator.incremental = 100;
        if (self.isGIF) {
            NSMutableArray *idleImages = [NSMutableArray array];
            for (NSUInteger i = 0; i<=27; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%zd", i]];
                [idleImages addObject:image];
            }
            LNHeaderAnimator *headerAnimator = (LNHeaderAnimator *)self.tableView.ln_header.animator;
            [headerAnimator changeHeaderType:LNRefreshHeaderType_GIF];
            [headerAnimator setImages:idleImages forState:LNRefreshState_Normal];
            [headerAnimator setImages:idleImages forState:LNRefreshState_Refreshing];
        }
    } else {
        //自定义刷新动画
        switch (self.DIYType) {
            case LNDemoDIYType_NOR: {
                [self.tableView addPullToRefresh:[LNHeaderDIYAnimator createAnimator] block:^{
                    [wself pullToRefresh];
                }];
                LNHeaderDIYAnimator *headerAnimator = (LNHeaderDIYAnimator *)self.tableView.ln_header.animator;
                headerAnimator.bgImageView.image = [UIImage imageNamed:@"refresh_bgimage_2.jpg"];
            }
                break;
            case LNDemoDIYType_DJ: {
                [self.tableView addPullToRefresh:[LNHeaderJDAnimator createAnimator] block:^{
                    [wself pullToRefresh];
                }];
            }
                break;
            case LNDemoDIYType_TMall: {
                [self.tableView addPullToRefresh:[LNHeaderTmallAnimator createAnimator] block:^{
                    [wself pullToRefresh];
                }];
            }
                break;
            case LNDemoDIYType_TaoBao: {
                [self.tableView addPullToRefresh:[LNHeaderTaobaoAnimator createAnimator] block:^{
                    [wself pullToRefresh];
                }];
            }
                break;
            case LNDemoDIYType_KaoLa: {
                [self.tableView addPullToRefresh:[LNHeaderKaolaAnimator createAnimator] block:^{
                    [wself pullToRefresh];
                }];
            }
                break;
            case LNDemoDIYType_Meituan: {
                [self.tableView addPullToRefresh:[LNHeaderMeituanAnimator createAnimator] block:^{
                    [wself pullToRefresh];
                }];
            }
                break;
            case LNDemoDIYType_NetEaseNews: {
                [self.tableView addPullToRefresh:[LNHeaderNetEaseNewsAnimator createAnimator] block:^{
                    [wself pullToRefresh];
                }];
            }
                break;
            case LNDemoDIYType_Toutiao: {
                [self.tableView addPullToRefresh:[LNHeaderToutiaoAnimator createAnimator] block:^{
                    [wself pullToRefresh];
                }];
            }
                break;
            case LNDemoDIYType_Feizhu: {
                [self.tableView addPullToRefresh:[LNHeaderFeizhuAnimator createAnimator] block:^{
                    [wself pullToRefresh];
                }];
            }
                break;
        }
    }
    [self.tableView startRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableVCCell"];
    if (indexPath.row < self.dataArr.count) {
        cell.textLabel.text = self.dataArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionView
- (void)createCollectionView {
    CGFloat itemW = (self.view.frame.size.width - 40) / 3.0 - 1;
    CGFloat itemH = itemW * 87 / 61 + 20;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 20.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, LNViewW, LNViewH) collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCellID"];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 60, 10);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) wself = self;
    // 默认刷新动画
    if (!self.isDIY) {
        [self.collectionView addPullToRefresh:^{
            [wself pullToRefresh];
        }];
        [self.collectionView addInfiniteScrolling:^{
            [wself loadMoreRefresh];
        }];
        if (self.isGIF) {
            NSMutableArray *idleImages = [NSMutableArray array];
            for (NSUInteger i = 0; i<=27; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%zd", i]];
                [idleImages addObject:image];
            }
            LNHeaderAnimator *headerAnimator = (LNHeaderAnimator *)self.collectionView.ln_header.animator;
            [headerAnimator changeHeaderType:LNRefreshHeaderType_GIF];
            [headerAnimator setImages:idleImages forState:LNRefreshState_Normal];
            [headerAnimator setImages:idleImages forState:LNRefreshState_Refreshing];
        }
    } else {  // 自定义刷新动画
        [self.collectionView addPullToRefresh:[LNHeaderDIYAnimator createAnimator] block:^{
            [wself pullToRefresh];
        }];
    }
    [self.collectionView startRefreshing];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellID" forIndexPath:indexPath];
    cell.backgroundColor = LNViewBGColor;
    if (cell.contentView.subviews.count == 0) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:cell.bounds];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (indexPath.row < self.dataArr.count) {
            titleLabel.text = self.dataArr[indexPath.row];
            [cell.contentView addSubview:titleLabel];
        }
    } else {
        UILabel *titleLabel = cell.contentView.subviews.firstObject;
        if (indexPath.row < self.dataArr.count) {
            titleLabel.text = self.dataArr[indexPath.row];
        }
    }
    return cell;
}

#pragma mark - UIWebView
- (void)createWebView {
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, LNViewW, LNViewH)];
    self.webView.backgroundColor = LNViewBGColor;
    self.webView.opaque = NO;
    self.webView.delegate = self;
    self.webView.scrollView.alwaysBounceVertical = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://wallstreetcn.com"]]];
    [self.view addSubview:self.webView];
    //刷新
    __weak typeof (self) wself = self;
    [self.webView.scrollView addPullToRefresh:^{
        [wself.webView reload];
    }];
    [self.webView.scrollView startRefreshing];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.webView.scrollView endRefreshing];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.webView.scrollView endRefreshing];
}

#pragma mark - UITextView
- (void)createTextView {
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, LNViewW, LNViewH)];
    self.textView.alwaysBounceVertical = YES;
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
    __weak typeof (self) wself = self;
    [self.textView addPullToRefresh:^{
        wself.textView.text = @"Every night in my dreams I see you, I feel you, That is how I know you go on Far across the";
        [wself refreshTextView];
    }];
    [self.textView startRefreshing];
}

- (void)refreshTextView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView endRefreshing];
    });
}

@end

