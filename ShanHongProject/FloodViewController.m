//
//  FloodViewController.m
//  ShanHongProject
//  #######当前汛情###
//  Created by teddy on 15/6/17.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FloodViewController.h"
#import "FloodDetailController.h"


@interface FloodViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation FloodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 44;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:(CGRect){20,0,self.view.frame.size.width,44}];
    textLabel.text = @"  汛情概要";
    self.myTableView.tableHeaderView = textLabel;
    
    listData = @[@"雨量站超警戒 2个",@"水位超警戒 3个",@"单站最大降雨量 20mm",@"1小时最大降雨量 10mm",@"当前台风 2个"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
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
    FloodDetailController *detail = [[FloodDetailController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
