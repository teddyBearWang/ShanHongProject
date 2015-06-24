
//
//  ProjectViewController.m
//  ShanHongProject
//      ####工情信息####
//  Created by teddy on 15/6/23.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectListController.h"

@interface ProjectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *listData;
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
    listData = @[@"水库",@"水闸",@"堤防",@"堰坝",@"水电站",@"山塘"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = listData[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListController *list = [[ProjectListController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"返回";
//    self.navigationItem.backBarButtonItem = backItem;
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

@end
