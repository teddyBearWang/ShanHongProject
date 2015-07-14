//
//  PlanDetailController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/14.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PlanDetailController.h"
#import "PlanObject.h"
#import "SVProgressHUD.h"

@interface PlanDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_listData;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PlanDetailController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [PlanObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [self.dic objectForKey:@"Sname"];
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self requestHttp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Method
- (void)requestHttp
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([PlanObject fetchWithType:@"GetFxPlanTree" level:@"1" sicd:[self.dic objectForKey:@"Sid"]]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //加载失败
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        _listData = [PlanObject requestDatas];
        [self.tableView reloadData];
    });
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = _listData[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"Sname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
