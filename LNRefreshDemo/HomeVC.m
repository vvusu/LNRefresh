//
//  HomeVC.m
//  LNRefresh
//
//  Created by vvusu on 7/12/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "HomeVC.h"
#import "DemoVC.h"
#import <LNRefresh/LNRefresh.h>

@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArr;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Home";
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *currentLanguage = languages.firstObject;
    NSLog(@"LN___当前语言：%@",currentLanguage);
    // 切换语言
//    NSArray *lans = @[@"en"];
//    [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeVCCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.dataArr = @[@"🐹UITableView",@"🐼UITableView_GIF",@"🐽UITableView_DIY",
                     @"🐮UICollectionView",@"🦁UICollectionView_GIF",@"🐸UICollectionView_DIY",
                     @"🐯UIWebView",@"🐶UITextView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeVCCell"];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DemoVC *vc = [[DemoVC alloc]init];
    switch (indexPath.row) {
        case 0:
            vc.vcType = LNDemoVCType_TableView;
            break;
        case 1: {
            vc.vcType = LNDemoVCType_TableView;
            vc.isGIF = YES;
        }
            break;
        case 2:
            vc.vcType = LNDemoVCType_TableView;
            vc.isDIY = YES;
            break;
        case 3:
            vc.vcType = LNDemoVCType_CollectionView;
            break;
        case 4:
            vc.vcType = LNDemoVCType_CollectionView;
            vc.isGIF = YES;
            break;
        case 5:
            vc.vcType = LNDemoVCType_CollectionView;
            vc.isDIY = YES;
            break;
        case 6: {
            vc.vcType = LNDemoVCType_WebView;
        }
            break;
        case 7: {
            vc.vcType = LNDemoVCType_TextView;
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
