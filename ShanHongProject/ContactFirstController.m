//
//  ContactFirstController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ContactFirstController.h"
#import "ContactViewController.h"

@interface ContactFirstController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listArray;//数据源
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ContactFirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"通讯录";
    
    UIButton *right_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    right_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    right_btn.frame = (CGRect){0,0,40,30};
    [right_btn setTitle:@"搜索" forState:UIControlStateNormal];
    [right_btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    right_btn.layer.borderColor = [UIColor whiteColor].CGColor;
    right_btn.layer.borderWidth = 0.5;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:right_btn];
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Methods
- (void)searchAction:(UIButton *)btn
{
    ContactViewController *contact = [[ContactViewController alloc] init];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    [self.navigationController pushViewController:contact animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"contact";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
