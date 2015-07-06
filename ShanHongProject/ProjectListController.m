//
//  ProjectListController.m
//  ShanHongProject
//  **************工情列表**************
//  Created by teddy on 15/6/23.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ProjectListController.h"
#import "ProjectDetailController.h"
#import "ProjectObject.h"
#import "SVProgressHUD.h"
#import "CustomHeaderView.h"
#import "WaterCell.h"

@interface ProjectListController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *listData;
}

@end

@implementation ProjectListController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //取消网络
        [ProjectObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.title_name;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    
    [self getProjectList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getProjectList
{
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([ProjectObject fetch:@"GetProjects" withProject:self.projectType]) {
            [SVProgressHUD dismissWithSuccess:@"加载成功"];
            dispatch_async(dispatch_get_main_queue(), ^{
                listData = [ProjectObject requestData];
                [_tableView reloadData];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
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
    WaterCell *cell = (WaterCell *)[tableView dequeueReusableCellWithIdentifier:@"WaterCell"];
    if (cell == nil) {
        cell = (WaterCell *)[[[NSBundle mainBundle] loadNibNamed:@"WaterCell" owner:self options:nil] lastObject];
    }
//    NSDictionary *dic = listData[indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.stationName.text = [[dic objectForKey:@"RSNM"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"RSNM"];
//    cell.lastestLevel.text = [[dic objectForKey:@"CANM"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"CANM"];
//    cell.warnWater.text = [[dic objectForKey:@"ADNM"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"ADNM"];
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectDetailController *detail = [[ProjectDetailController alloc] init];
    detail.Object_dic = listData[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem = item;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *view = [[CustomHeaderView alloc] initWithFirstLabel:@"名称" withSecond:@"所属流域" withThree:@"所属乡镇"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
@end
