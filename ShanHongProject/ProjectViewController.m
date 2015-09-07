
//
//  ProjectViewController.m
//  ShanHongProject
//      ####工情信息####
//  Created by teddy on 15/6/23.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectListController.h"
#import "FilterViewController.h"
#import "ProjectObject.h"
#import "FilterObject.h"

@interface ProjectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *listData;
    NSArray *images;//存放图标
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
//    listData = @[@"水库",@"闸门",@"水电站",@"山塘"];
//    images = @[@"sk",@"sz",@"sdz",@"st"];
    
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(filterAction:)];
    self.navigationItem.rightBarButtonItem = filter;
    
    [self getProjectItmes];
}

- (void)viewWillLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Method

//本地化
- (NSDictionary *)getUserInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [user objectForKey:STATION];
    return userDic;
}

- (void)getProjectItmes
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSDictionary *dic = [self getUserInfo];
    NSString *result = [NSString stringWithFormat:@"%@$gq",[dic objectForKey:@"Scityid"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([ProjectObject fetch:@"GetMyProjectsList" withProject:result]) {
            //获取成功
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //失败
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        listData = [ProjectObject requestData];
        if (listData.count != 0) {
            [self.tableView reloadData];
        }
    });
}

- (void)filterAction:(id)sender
{
    [SVProgressHUD show];
    __block NSArray *filterDatas = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([FilterObject fetchFilterDataWithType:@"GetProjectsSearch"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithSuccess:nil];
                filterDatas = [FilterObject requestData];
                FilterViewController *filter = [[FilterViewController alloc] init];
                filter.data = filterDatas;//传递数据
                filter.filterType =  ProjectFilter;
                filter.title_name = @"工情搜索";
                [self.navigationController pushViewController:filter animated:YES];
            });
        }else{
            filterDatas = [NSArray array];
        }
    });
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSDictionary *dic = listData[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"SmodelName"];
    cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"SmodelIcon"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //listData = @[@"水库",@"水闸",@"堤防",@"堰坝",@"水电站",@"山塘"];
    
//    NSString *type = @"";
//    NSString *titleName = @"";
//    switch (indexPath.row) {
//        case 0:
//            type = @"sk";
//            titleName = @"水库信息";
//            break;
//        case 1:
//            type = @"sz";
//            titleName = @"闸门信息";
//            break;
////        case 2:
////            type = @"df";
////            titleName = @"堤防信息";
////            break;
//        case 2:
//            type = @"sdz";
//            titleName = @"水电站信息";
//            break;
//        case 3:
//            type = @"st";
//            titleName = @"山塘信息";
//            break;
//        default:
//            break;
//    }
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
    ProjectListController *listCtrl = [[ProjectListController alloc] init];
    listCtrl.projectType = [dic objectForKey:@"SmodelIcon"];
    listCtrl.title_name = [dic objectForKey:@"SmodelName"];
    listCtrl.requestType = @"GetProjects"; //请求工情
    listCtrl.labelArray = @[@"名称",@"所属流域",@"所属乡镇"];
    [self.navigationController pushViewController:listCtrl animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
#endif
}

@end
