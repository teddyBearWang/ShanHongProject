//
//  SettingViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SettingViewController.h"
#import "SingleInstanceObject.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"

static AFHTTPRequestOperation *_operation = nil;
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_listData;
    SingleInstanceObject *_segton;//单例
    NSString *_webVer;//网页版本
}
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)changeAccountAction:(id)sender;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _listData = @[@"消息提醒",@"清除缓存",@"当前版本",@"关于"];
    //_listData = @[@"消息提醒",@"清除缓存",@"关于"];
    _segton = [SingleInstanceObject defaultInstance];
    self.view.backgroundColor = BG_COLOR;
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.setBtn.layer.cornerRadius = 5.0;
    self.setBtn.layer.borderWidth = 0.5;
    self.setBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [SVProgressHUD showWithStatus:@"获取网络版本号"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getWebVersionWithSuccessBlock:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            _webVer = [dict objectForKey:@"version"];
            [self.myTableView reloadData];
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
        UILabel *version = [[UILabel alloc] initWithFrame:(CGRect){200,7,100,30}];
        version.tag = 101;
        version.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:version];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 3) {
        UILabel *version = (UILabel *)[self.view viewWithTag:101];
        if ([self compareWithAppVersion]) {
            version.text = [NSString stringWithFormat:@"最新版本: %@",_webVer];
        }else{
            version.text = @"当前已是最新版本";
        }
    }
    cell.textLabel.text = _listData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"设置成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"缓存已经清除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case 2:
        {
            
            if ([self compareWithAppVersion]) {
                //跳转到appStore
               // NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/shan-hong-fang-zhi/id1020614336?mt=8"];
                NSString *str = @"http://fir.im/shanHongFangZhi";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
             
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"杭州定川信息技术有限公司版权所有" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
       }
            
            break;
            
        case 3:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"杭州定川信息技术有限公司版权所有" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//获取网络版本数据
- (void)getWebVersionWithSuccessBlock:(void(^)(NSDictionary *dict))successBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *str = @"http://api.fir.im/apps/latest/56306717e75e2d5191000004?api_token=082701147ad92d225ce9cc6f45ff3638";
    _operation = [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功
        NSDictionary *resDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        successBlock(resDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismissWithError:@"获取版本号失败"];
    }];
}

////版本比较，有新版本返回YES，无新版本返回NO
- (BOOL)compareWithAppVersion
{
    if (![_segton.serverVersions isEqualToString:@""]) {
        //先获取当前软件版本号
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if (![_webVer isEqualToString:currentVersion]) {
            //有新版本
            return YES;
        }else{
            //没有新版本
            return NO;
        }
    }else{
        //版本号为空，不更新
        return NO;
    }
}

- (IBAction)changeAccountAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
