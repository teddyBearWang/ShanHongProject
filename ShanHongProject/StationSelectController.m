//
//  StationSelectController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "StationSelectController.h"
#import "SiteObject.h"
#import "SVProgressHUD.h"
#import "SingleInstanceObject.h"
#define Bar_Height 44

@interface StationSelectController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *listData;
    NSString *selectArea;
}

@end

@implementation StationSelectController

- (void)initNavBar
{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, Bar_Height)];
    bar.translucent = NO;
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    bar.barTintColor = [UIColor blueColor];
    [self.view addSubview:bar];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.title = @"站点选择";
    [bar pushNavigationItem:navigationItem animated:YES];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = (CGRect){0,0,50,40};
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    navigationItem.leftBarButtonItem = left;
    
    UIButton *comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmBtn.frame = (CGRect){0,0,50,40};
    comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [comfirmBtn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:comfirmBtn];
    navigationItem.rightBarButtonItem = right;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavBar];
    
    myTableView = [[UITableView alloc] initWithFrame:(CGRect){0,Bar_Height,self.view.frame.size.width,self.view.frame.size.height - Bar_Height} style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([SiteObject fetchSite]) {
            [SVProgressHUD dismissWithSuccess:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                listData = [SiteObject requestDatas];
                //主界面更新UI
                [myTableView reloadData];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:nil];
            });
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Method
- (void)cancelAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)comfirmAction:(UIButton *)btn
{
    if (selectArea.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一个站点" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self.delegate selectStationAction:selectArea];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - UITableVIewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = [listData[indexPath.row] objectForKey:@"ScityName"];
    return cell;
}

static NSInteger _selectRow;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectRow >= 0) {
        //取消上一次选中
        NSIndexPath *oldIndex = [NSIndexPath indexPathForRow:_selectRow inSection:0];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:oldIndex];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectRow = indexPath.row;
    NSDictionary *dic = listData[indexPath.row];
    selectArea = [dic objectForKey:@"ScityName"];
    SingleInstanceObject *instance = [SingleInstanceObject defaultInstance];
    instance.Scityid = [dic objectForKey:@"Scityid"];
    instance.ScityName = [dic objectForKey:@"ScityName"];
    instance.SproxyUrl = [dic objectForKey:@"SproxyUrl"];
    instance.ScenterLng = [dic objectForKey:@"ScenterLng"];
    instance.ScenterLat = [dic objectForKey:@"ScenterLat"];
    instance.ScenterZoom = [dic objectForKey:@"ScenterZoom"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
