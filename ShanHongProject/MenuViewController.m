//
//  MenuViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MenuViewController.h"
#import "ContactViewController.h"
#import "UntilObject.h"
#import "SingleInstanceObject.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"

static AFHTTPRequestOperation *_operation = nil;
@interface MenuViewController ()<UIAlertViewDelegate>
{
    
    __weak IBOutlet UIButton *fxjz_btn;
    __weak IBOutlet UIImageView *_bgView;
    __weak IBOutlet UIImageView *_imageView;
    
    __weak IBOutlet UILabel *_weatherLabel;
    __weak IBOutlet UILabel *_dateLabel;
    
    __weak IBOutlet UILabel *_tempureLabel;
    SingleInstanceObject *_segton;
    
}

- (IBAction)contactSelectAction:(id)sender;


@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"山洪防治移动平台";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    _bgView.backgroundColor = [UIColor colorWithRed:4/255.0 green:17/255.0 blue:49/255.0 alpha:1];
    
    _dateLabel.text = [UntilObject getSystemdate];
    _weatherLabel.text = [self.loginDic objectForKey:@"stxt"];
    _tempureLabel.text = [self.loginDic objectForKey:@"stemperature"];
    
    
    
//     //提醒软件更新
//    _segton = [SingleInstanceObject defaultInstance];
//    if ([self compareWithAppVersion]) {
//        NSString *str = [NSString stringWithFormat:@"当前有最新版本%@,是否立即更新",_segton.serverVersions];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//        [alert show];
//    }
    
    [SVProgressHUD showWithStatus:@"获取网络版本号"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getWebVersionWithSuccessBlock:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            NSString *webVer = [dict objectForKey:@"version"];
            if ([self compareWithAppVersion:webVer]) {
                NSString *str = [NSString stringWithFormat:@"当前有最新版本%@,是否立即更新",webVer];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [alert show];
            }
        }];
    });
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma maek - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
       // NSString *str = [NSString stringWithFormat:@"http://115.236.2.245:38019/sh2.html"];
        NSString *str = @"http://fir.im/shanHongFangZhi";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}


//版本比较，有新版本返回YES，无新版本返回NO
//- (BOOL)compareWithAppVersion
//{
//    if (![_segton.serverVersions isEqualToString:@""]) {
//        //先获取当前软件版本号
//        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        
//        if (![_segton.serverVersions isEqualToString:currentVersion]) {
//            //有新版本
//            return YES;
//        }else{
//            //没有新版本
//            return NO;
//        }
//    }else{
//        //版本号为空，不更新
//        return NO;
//    }
//}

//版本比较，有新版本返回YES，无新版本返回NO
- (BOOL)compareWithAppVersion:(NSString *)verson
{
    if (![verson isEqualToString:@""]) {
        //先获取当前软件版本号
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if (![verson isEqualToString:currentVersion]) {
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

- (IBAction)contactSelectAction:(id)sender
{
    ContactViewController *contact = [[ContactViewController alloc] init];
    [self.navigationController pushViewController:contact animated:YES];
}

@end
