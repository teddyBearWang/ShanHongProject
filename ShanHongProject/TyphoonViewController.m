//
//  TyphoonViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "TyphoonViewController.h"

@interface TyphoonViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *typhoonView;

@end

@implementation TyphoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadWebView
{
    //http://typhoon.zjwater.gov.cn/default.aspx
    NSString *str = @"http://typhoon.zjwater.gov.cn/wap.htm";
    NSURL *url = [NSURL URLWithString:str];
    [self.typhoonView loadRequest:[NSURLRequest requestWithURL:url]];
}
@end
