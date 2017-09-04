<p align="center">
  <img src="./images/banner.png">
</p>

<p align="center">
<a href="#demo">Demo</a> -
<a href="#installation">Installation</a> -
<a href="#documents">Documents</a> -
<a href="#contribution">Contribution</a>
</p>
    
<p align="center">
<a href="http://cocoadocs.org/docsets/LNRefresh"><img src="https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat"></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
<a href="https://developer.apple.com/ios"><img src="https://img.shields.io/badge/platform-iOS%207%2B-blue.svg?style=flat"></a>
<a href="https://github.com/wedxz/LNRefresh/tree/1.0.1"><img src="https://img.shields.io/badge/release-1.0.1-blue.svg"></a>
<a href="https://www.gnu.org/licenses/gpl-3.0"><img src="https://img.shields.io/badge/License-GPL%20v3-blue.svg"></a>
</p>

# LNRefresh
LNRefresh Is a lightweight, can dynamically expand the drop-down refresh component

#### Support what kinds of controls to refresh
`UIScrollView`、`UITableView`、`UICollectionView`、`UIWebView`、`UITextView`

## Demo
GIF picture from [华尔街见闻](https://wallstreetcn.com/)

| Style   | Demo |
| ---   | --- |
| Usually style | ![](./images/demo_1.gif) |
| Dynamically change the style | ![](./images/demo_2.gif) |

## Customize Demos
| APP   | Demo |
| ---   | --- |
| 京东 | ![](./images/demo_jd.gif) |
| 天猫 | ![](./images/demo_tmall.gif) |
| 淘宝 | ![](./images/demo_taobao.gif) |
| 考拉海购 | ![](./images/demo_kaola.gif) |
| 美团外卖 | ![](./images/demo_meituan.gif) |
| 网易新闻 | ![](./images/demo_neteasenews.gif) |
| 今日头条 | ![](./images/demo_toutiao.gif) |
| 飞猪 | ![](./images/demo_feizhu.gif) |

## Installation
### CocoaPods
Installation with CocoaPods:

```
pod 'LNRefresh'
```
### Carthage
Installation with Cartfile:

```
github "wedxz/LNRefresh"
```
## Documents
#### How to use LNRefresh
###### Add pull to refresh
```
__weak typeof (self) wself = self;
//UITableView
[self.tableView addPullToRefresh:^{
  [wself pullToRefresh];
}];

//UICollectionView
[self.collectionView addPullToRefresh:^{
  [wself pullToRefresh];
}];

//UIWebView
[self.webView.scrollView addPullToRefresh:^{
   [wself.webView reload];
}];
```
###### End Pull to refresh
```
//UITableView
[self.tableView endRefreshing];

//UICollectionView
[self.collectionView endRefreshing];

//UIWebView
[self.webView.scrollView endRefreshing];
```
###### Add Loading more
```
//UITableView
[self.tableView addInfiniteScrolling:^{
  [wself loadMoreRefresh];
}];

//UICollectionView
[self.collectionView addInfiniteScrolling:^{
  [wself loadMoreRefresh];
}];
```
###### End Loading more
```
//UITableView
[self.tableView endLoadingMore];

//UICollectionView
[self.tableView endLoadingMore];
```
###### No More data
```
//UITableView
[self.tableView noticeNoMoreData];

//UICollectionView
[self.tableView noticeNoMoreData];
```
###### Auto Refresh
```
[self.scrollView startRefreshing];
```
###### Change the trigger to pull the refresh distance
```
self.tableView.ln_header.animator.trigger = 100;
```

#### Global Settings
###### Set the GIF image
```
+ (void)setAllHeaderAnimatorStateImages:(NSArray *)stateImages
                                  state:(LNRefreshState)state;

+ (void)setAllHeaderAnimatorStateImages:(NSArray *)stateImages
                                  state:(LNRefreshState)state
                               duration:(NSTimeInterval)duration;
```
###### Change the global pull-down refresh pattern state
```
+ (void)changeAllHeaderAnimatorType:(LNRefreshHeaderType)type;

+ (void)changeAllHeaderAnimatorType:(LNRefreshHeaderType)type
                            bgImage:(UIImage *)image;

+ (void)changeAllHeaderAnimatorType:(LNRefreshHeaderType)type
                            bgImage:(UIImage *)image
                        incremental:(CGFloat)incremental;
```

#### Customize RefreshAnimator
You Need to inherit LNHeaderAnimator，Rewrite the following method.

```
- (void)setupHeaderView_DIY;
- (void)layoutHeaderView_DIY;
- (void)refreshHeaderView_DIY:(LNRefreshState)state;
- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress;
```
Example: `LNHeaderDIYAnimator.m`

#### Analysis
Example: `LNHeaderAnimator+Analysis.m`

## Contribution
[vvusu](https://github.com/wedxz)
## License
<a href="https://www.gnu.org/licenses/gpl-3.0"><img src="https://img.shields.io/badge/License-GPL%20v3-blue.svg"></a>

Copyright (c) 2017 vvusu 


