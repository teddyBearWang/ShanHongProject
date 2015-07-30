//
//  ContactThirdController.m
//  ShanHongProject
//  ***********通讯录第三级*************
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ContactThirdController.h"
#import "ContactForthController.h"
#import "PeopleController.h"
#import "ContactObject.h"
#import "SVProgressHUD.h"

@interface ContactThirdController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSArray *listData;//数据源
}

@end

@implementation ContactThirdController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [SVProgressHUD dismiss];
        [ContactObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.title_name;
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height - kTableViewmargin} style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    [self getWebData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWebData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([ContactObject fetch:self.sid]) {
            //成功
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
        listData = [ContactObject requestData];
        if (listData.count != 0) {
            [_tableView reloadData];
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
    static NSString *identifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [listData[indexPath.row] objectForKey:@"personNM"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sid = [listData[indexPath.row] objectForKey:@"PersonCD"];
    NSString *title = [listData[indexPath.row] objectForKey:@"personNM"];

    if ([sid containsString:@"s"]) {
        //本级
        PeopleController *people = [[PeopleController alloc] init];
        people.sid = sid;//传递编号
        people.title_name = title;
        [self.navigationController pushViewController:people animated:YES];
    }else{
        ContactForthController *forth = [[ContactForthController alloc] init];
        forth.sid = sid;//编号传递
        forth.title_name = title;
        [self.navigationController pushViewController:forth animated:YES];
    }
}
@end
