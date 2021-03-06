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

@interface StationSelectController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *listData;
    NSString *selectArea;
    NSDictionary *_selectDic;//选中的站点对象
}

@end

@implementation StationSelectController

- (void)initNavBar
{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, Bar_Height)];
    bar.translucent = NO;
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    bar.barTintColor = [UIColor colorWithRed:4/255.0 green:17/255.0 blue:49/255.0 alpha:1];
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
    
    myTableView = [[UITableView alloc] initWithFrame:(CGRect){0,Bar_Height,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - Bar_Height} style:UITableViewStylePlain];
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
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:^{
        [SiteObject cancelRequest];
    }];
}

- (void)comfirmAction:(UIButton *)btn
{
    if (selectArea.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一个站点" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        SingleInstanceObject *instance = [SingleInstanceObject defaultInstance];
        instance.Scityid = [_selectDic objectForKey:@"Scityid"];
        instance.ScityName = [_selectDic objectForKey:@"ScityName"];
        instance.SproxyUrl = [_selectDic objectForKey:@"SproxyUrl"];
        instance.ScenterLng = [_selectDic objectForKey:@"ScenterLng"];
        instance.ScenterLat = [_selectDic objectForKey:@"ScenterLat"];
        instance.ScenterZoom = [_selectDic objectForKey:@"ScenterZoom"];
        
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
    static NSString *identifer = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    //检查本地存储着的站点，默认显示“选择状态”
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:STATION] objectForKey:@"ScityName"] isEqualToString:[listData[indexPath.row] objectForKey:@"ScityName"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //默认选择
        _selectRow = indexPath.row;
        selectArea = [[[NSUserDefaults standardUserDefaults] objectForKey:STATION] objectForKey:@"ScityName"];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [listData[indexPath.row] objectForKey:@"ScityName"];
    return cell;
}

static NSInteger _selectRow = 0;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消上一次选中
    NSIndexPath *oldIndex = [NSIndexPath indexPathForRow:_selectRow inSection:0];
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:oldIndex];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    //重新选择
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectRow = indexPath.row;
    
    //将所选的站点的信息赋值给单例保存
    NSDictionary *dic = listData[indexPath.row];
    //将站点信息保存在本地
    _selectDic = dic;
    selectArea = [_selectDic objectForKey:@"ScityName"];
    [self saveInfo:dic];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//本地化
- (void)saveInfo:(NSDictionary *)dic
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:dic forKey:STATION];
    [user synchronize];
}

@end
