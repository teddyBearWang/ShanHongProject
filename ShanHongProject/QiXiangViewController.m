//
//  QiXiangViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "QiXiangViewController.h"
#import "QxDetailController.h"

@interface QiXiangViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation QiXiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 44;
    
    listData = @[@"一小时降水预报",@"三小时降水预报",@"卫星云图",@"气象雷达"];
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
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = listData[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QxDetailController *qx = [[QxDetailController alloc] init];
    switch (indexPath.row) {
        case 0:
            //一小时强降水
            qx.type = @"rain1h$";
            break;
        case 1:
            //三小时强降水
            qx.type = @"rain3h$";
            break;
        case 2:
            //卫星云图
            qx.type = @"wxyt$";
            break;
        case 3:
            //气象雷达
            qx.type = @"qxld$";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:qx animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
