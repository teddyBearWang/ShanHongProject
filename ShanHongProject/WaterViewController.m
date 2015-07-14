//
//  WaterViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterViewController.h"
#import "SVProgressHUD.h"
#import "WaterCell.h"
#import "RainObject.h"
#import "CustomRainHeaderView.h"
#import "RainChartController.h"
#import "MyTimeView.h"
#import "HeaderView.h"
#import "UIView+RootView.h"
#import "FilterViewController.h"
#import "FilterObject.h"

@interface WaterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;//数据源
    UITableView *_myTableView;
    NSArray *_headers;// 列表头部视图的字段
    NSMutableArray *_stations;//站点tableVIew的数据源
    
    NSUInteger _kCount;
}

@property (strong, nonatomic)  UIView *myTableViewHeaderView;

@property (nonatomic, strong) MyTimeView *myTimeView;
@end

@implementation WaterViewController

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

- (void)initDatas
{
    _headers = @[@"最新(m)",@"最新时间",@"超警(m)",@"库容(万m³)",@"最大值(m)",@"最大时间",@"汛线"];
    _kCount = _headers.count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"水情信息";
    self.view.backgroundColor = BG_COLOR;
    
    [self initDatas];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:(CGRect){0,0,_kCount * kWidth, kHeight}];
    tableHeaderView.backgroundColor = BG_COLOR;
    self.myTableViewHeaderView = tableHeaderView;
    
    for (int i=0; i<_kCount; i++) {
        HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(i*kWidth, 0, kWidth, kHeight)];
        header.num = _headers[i];
        [tableHeaderView addSubview:header];
    }
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.myTableViewHeaderView.frame.size.width, kScreen_height) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.bounces = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth, 0, kScreen_Width - kWidth, kScreen_height)];
    [scrollView addSubview:_myTableView];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(self.myTableViewHeaderView.frame.size.width, 0);
    [self.view addSubview:scrollView];
    
    self.myTimeView = [[MyTimeView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kScreen_height)];
    self.myTimeView.listData = _stations;
    self.myTimeView.headTitle = @"站点";
    [self.view addSubview:self.myTimeView];
    
    UIButton *selct_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    selct_btn.frame = (CGRect){0,0,20,20};
    [selct_btn setCorners:5.0];
    [selct_btn setBackgroundImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [selct_btn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:selct_btn];
    self.navigationItem.rightBarButtonItem = item;
    
    [self refresh:@"GetSqInfo"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //用户点击返回,取消用户请求
        [RainObject cancelRequest];
    }
}

- (void)filterAction:(id)sender
{
    [SVProgressHUD show];
    __block NSArray *filterDatas = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([FilterObject fetchFilterDataWithType:@"GetSqInfoSearch"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithSuccess:nil];
                filterDatas = [FilterObject requestData];
                FilterViewController *filter = [[FilterViewController alloc] init];
                filter.data = filterDatas;//传递数据
                filter.filterType =  WaterStationFilter;
                filter.title_name = @"水情站点搜索";
                [self.navigationController pushViewController:filter animated:YES];
            });
        }else{
            filterDatas = [NSArray array];
        }
    });
}

- (void)refresh:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RainObject fetch:type]) {
            //更新UI
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败~"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        listData = [RainObject requestData];
        _stations = [NSMutableArray arrayWithCapacity:listData.count];
        for (NSDictionary *dic in listData) {
            [_stations addObject:[dic objectForKey:@"stnm"]];
        }
        [_myTableView reloadData];
        [self.myTimeView refrushTableView:_stations];
    });
}
#pragma mark - UITableViewDataSOurce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //有数据的时候
    WaterCell *cell = (WaterCell *)[tableView dequeueReusableCellWithIdentifier:@"RainCell"];
    if (cell == nil) {
        cell = ( WaterCell*)[[[NSBundle mainBundle] loadNibNamed:@"WaterCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
    cell.lastestLevel.text = [[dic objectForKey:@"new"] isEqual:@""] ? @"--" : [dic objectForKey:@"new"];
    NSLog(@"得到的最新时间:%@",[dic objectForKey:@"newTime"]);
    cell.lastestTime.text = [[dic objectForKey:@"newTime"] isEqual:@""] ? @"--" : [dic objectForKey:@"newTime"];
    cell.warnWater.text = [[dic objectForKey:@"max"] isEqual:@""] ? @"--" : [dic objectForKey:@"max"];
    cell.capacity.text = @"10000";
    cell.maxLevel.text = [[dic objectForKey:@"max"] isEqual:@""] ? @"--" : [dic objectForKey:@"max"];
    cell.maxTime.text = [[dic objectForKey:@"maxTime"] isEqual:@""] ? @"--" : [dic objectForKey:@"maxTime"];
    cell.floodWarn.text = @"10000";
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.myTableViewHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = listData[indexPath.row];
    RainChartController *chart = [[RainChartController alloc] init];
    chart.title_name = dic[@"stnm"];
    chart.stcd = dic[@"stcd"];
    chart.requestType = @"GetStDaySW";
    chart.chartType = 1; //表示柱状图
    [self.navigationController pushViewController:chart animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSetY = _myTableView.contentOffset.y;//_myTableView的Y向偏移量
    
    CGPoint timeViewOffSet = self.myTimeView.myTableView.contentOffset;
    timeViewOffSet.y = offSetY;
    self.myTimeView.myTableView.contentOffset = timeViewOffSet;
    if (offSetY == 0) {
        self.myTimeView.myTableView.contentOffset = timeViewOffSet;
    }
}

@end
