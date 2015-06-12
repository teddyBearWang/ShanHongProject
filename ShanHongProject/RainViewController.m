//
//  RainViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RainViewController.h"
#import "RainCell.h"

@interface RainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation RainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 44;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    RainCell *cell = (RainCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (RainCell *)[[[NSBundle mainBundle] loadNibNamed:@"Rain" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"RainHeaderView" owner:self options:nil] lastObject];
    headView.backgroundColor = BG_COLOR;
    return headView;
}

@end
