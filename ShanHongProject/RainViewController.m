//
//  RainViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RainViewController.h"
#import "RainCell.h"
#import "RainObject.h"
#import "UIView+RootView.h"
#import "SVProgressHUD.h"
#import "CustomHeaderView.h"
#import "ChartViewController.h"
#import "FilterViewController.h"

@interface RainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;
    NSMutableArray *sourceDatas;//所有数据
    BOOL ret;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation RainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //强制屏幕横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"实时雨情";
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 44;
    
    UIButton *selct_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    selct_btn.frame = (CGRect){0,0,20,20};
    [selct_btn setCorners:5.0];
    [selct_btn setBackgroundImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [selct_btn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:selct_btn];
    self.navigationItem.rightBarButtonItem = item;

    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //用户点击了返回按钮
        [RainObject cancelRequest];
    }
}

#pragma mark - private
- (void)refresh
{
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RainObject fetch:@"GetYqInfo"]) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [SVProgressHUD dismissWithSuccess:@"加载成功"];
               ret = YES;
               listData = [RainObject requestData];
               sourceDatas = [NSMutableArray arrayWithArray:listData];
               [self.myTableView reloadData];
           });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
                ret = NO;
            });
        }
    });
}



- (void)filterAction:(UIButton *)btn
{
    FilterViewController *filter = [[FilterViewController alloc] init];
    [self.navigationController pushViewController:filter animated:YES];
}

#pragma mark  - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ret) {
        static NSString *identifier = @"MyCell";
        RainCell *cell = (RainCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = (RainCell *)[[[NSBundle mainBundle] loadNibNamed:@"Rain" owner:nil options:nil] lastObject];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *dic = listData[indexPath.row];
        cell.stationName.text = [[dic objectForKey:@"stnm"] isEqualToString:@""] ? @"--": [dic objectForKey:@"stnm"];
        cell.oneHour.text = [[dic objectForKey:@"rain1h"] isEqualToString:@""] ? @"--": [dic objectForKey:@"rain1h"];
        cell.threeHour.text = [[dic objectForKey:@"rain3h"] isEqualToString:@""] ? @"--": [dic objectForKey:@"rain3h"];
        cell.today.text = [[dic objectForKey:@"raintoday"] isEqualToString:@""] ? @"--": [dic objectForKey:@"raintoday"];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    }
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"RainHeaderView" owner:self options:nil] lastObject];
    headView.backgroundColor = BG_COLOR;
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = listData[indexPath.row];
    ChartViewController *chart = [[ChartViewController alloc] init];
    chart.title_name = dic[@"stnm"];
    chart.stcd = dic[@"stcd"];
    chart.requestType = @"GetStDayLjYl";
    chart.chartType = 2; //表示柱状图
    [self.navigationController pushViewController:chart animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
