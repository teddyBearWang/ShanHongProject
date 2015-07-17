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

@interface MenuViewController ()
{
    
    __weak IBOutlet UIImageView *_bgView;
    __weak IBOutlet UIImageView *_imageView;
    
    __weak IBOutlet UILabel *_weatherLabel;
    __weak IBOutlet UILabel *_dateLabel;
    
    __weak IBOutlet UILabel *_tempureLabel;
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)contactSelectAction:(id)sender
{
    ContactViewController *contact = [[ContactViewController alloc] init];
    [self.navigationController pushViewController:contact animated:YES];
}
@end
