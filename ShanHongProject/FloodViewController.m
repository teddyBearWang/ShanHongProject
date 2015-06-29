//
//  FloodViewController.m
//  ShanHongProject
//  #######当前汛情###
//  Created by teddy on 15/6/17.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FloodViewController.h"
#import "FloodDetailController.h"
#import "FloodObject.h"
#import "SVProgressHUD.h"

@interface FloodViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation FloodViewController


-  (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [FloodObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 44;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:(CGRect){20,0,self.view.frame.size.width,44}];
    textLabel.text = @"  汛情概要";
    self.myTableView.tableHeaderView = textLabel;
    
    [self getWebData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWebData
{
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([FloodObject fetch]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        listData = [FloodObject requestData];
        [self.myTableView reloadData];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = [listData lastObject];
    //    listData = @[@"雨量站超警戒 2个",@"水位超警戒 3个",@"单站当日最大降雨量 20mm",@"1小时最大降雨量 10mm",@"当前台风 2个"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"雨量站超警戒 %@个",[dic objectForKey:@"RainCount"]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"水位超警戒 %@个",[dic objectForKey:@"WaterCount"]];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"单站当日最大降雨量 %@mm",[dic objectForKey:@"Maxr24hValue"]];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"单站当日最大1小时最大降雨量 %@mm",[dic objectForKey:@"Maxr1hValue"]];
            break;
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"当前台风 %@个",[dic objectForKey:@"TfCount"]];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FloodDetailController *detail = [[FloodDetailController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
