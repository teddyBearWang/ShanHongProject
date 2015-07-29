//
//  PeopleController.m
//  ShanHongProject
//  *********显示详细人员界面*****
//  Created by teddy on 15/7/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PeopleController.h"
#import "ContactCell.h"

@interface PeopleController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *list;//数据源
}

@end

@implementation PeopleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height - 64} style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (ContactCell *)[[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:nil options:nil] lastObject];
    }
    
    NSDictionary *dic = list[indexPath.row];
    [cell updateCell:dic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = list[indexPath.row];
    NSString *str = [dic objectForKey:@"Mobile"];
    [self takePhone:str];
    
}

//调用系统打电话功能
- (void)takePhone:(NSString *)num
{
    if (num.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您选择的号码是空号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"tel://%@",num];
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
}

@end
