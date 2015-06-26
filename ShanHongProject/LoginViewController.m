//
//  LoginViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuViewController.h"
#import "StationSelectController.h"
#import "SingleInstanceObject.h"

@interface LoginViewController ()<selectDelegate>
{
    UIButton *statusBtn;//站点
}
@property (weak, nonatomic) IBOutlet UINavigationBar *bar; //导航栏
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *psw;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *user_image;

@property (weak, nonatomic) IBOutlet UIImageView *psw_image;
@property (weak, nonatomic) IBOutlet UIView *user_bg_view;
@property (weak, nonatomic) IBOutlet UIView *psw_bg_view;

- (IBAction)loginAction:(id)sender;

@end

@implementation LoginViewController

- (void)initNavBar
{
    self.bar.translucent = NO;
    [self.bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.bar.barTintColor = [UIColor colorWithRed:4/255.0 green:17/255.0 blue:49/255.0 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    [self initNavBar];
    
    statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    statusBtn.frame = (CGRect){0,0,50,30};
    statusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [statusBtn setTitle:@"站点" forState:UIControlStateNormal];
    [statusBtn addTarget:self action:@selector(stationSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:statusBtn];
    
    UINavigationItem *nabigationItem = [[UINavigationItem alloc] init];
    [nabigationItem setHidesBackButton:YES];//隐藏返回按钮=
    nabigationItem.title = @"登陆";
    nabigationItem.rightBarButtonItem = item;
    [self.bar pushNavigationItem:nabigationItem animated:YES];
    
    self.user_bg_view.layer.cornerRadius = 5.0;
    self.user_bg_view.layer.masksToBounds = YES;
    self.user_image.image = [UIImage imageNamed:@"user"];
    
    self.psw_bg_view.layer.cornerRadius = 5.0;
    self.psw_bg_view.layer.masksToBounds = YES;
    self.psw.secureTextEntry = YES;
    self.psw_image.image = [UIImage imageNamed:@"password"];
    
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.backgroundColor = [UIColor colorWithRed:56/255.0 green:131/255.0 blue:238/255.0 alpha:1.0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MenuViewController *menu = (MenuViewController *)[story instantiateViewControllerWithIdentifier:@"menu"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menu];
    nav.navigationBar.barTintColor = [UIColor colorWithRed:4/255.0 green:17/255.0 blue:49/255.0 alpha:1];
    nav.navigationBar.tintColor = [UIColor whiteColor];//修改返回按钮的颜色
   // nav.interactivePopGestureRecognizer.enabled = NO; 禁止左滑返回手势
    //设置标题颜色
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nav.navigationBar.translucent = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [self presentViewController:nav animated:YES completion:NULL];
    
    [UIView commitAnimations];
    
}

//站点选择
- (void)stationSelectAction:(UIButton *)btn
{
    StationSelectController *station = [[StationSelectController alloc] init];
    station.delegate = self;
    [self presentViewController:station animated:YES completion:NULL];
}

#pragma mark - SelectStationDelegate
- (void)selectStationAction:(NSString *)area
{
    [statusBtn setTitle:area forState:UIControlStateNormal];
}
@end
