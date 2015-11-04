//
//  WebChartController.m
//  ShanHongProject
//  ************网页图表***********
//  Created by teddy on 15/11/4.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WebChartController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "UntilObject.h"

@interface WebChartController ()<UIWebViewDelegate>
{
    UIWebView *_chartView;//网页视图
    NSString *_typeUrl;
    
    CGFloat _ViewHeight;
    CGFloat _ViewWidth;
}

@end

@implementation WebChartController



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //禁止横屏
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isFull = NO;
    //
    [SVProgressHUD dismiss];
    [_chartView stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //允许横屏
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isFull = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientationAction:) name:DEVICE_ORIENTATION_CHANGE object:nil];
    
    if ([self.chartType isEqualToString:@"1"]) {
        //折线图
        _typeUrl = @"http://webservices.qgj.cn/wt_rtest/ShChart5/index.html#myline";
          self.title = [NSString stringWithFormat:@"%@水位折线图",self.cityName];
    }else{
        //表示柱状图
        _typeUrl = @"http://webservices.qgj.cn/wt_rtest/ShChart5/index.html#mybar";
          self.title = [NSString stringWithFormat:@"%@雨量柱状图",self.cityName];
    }
    
    _ViewHeight = self.view.frame.size.height;
    _ViewWidth = self.view.frame.size.width;
    _chartView = [[UIWebView alloc] initWithFrame:(CGRect){0,0,_ViewWidth,_ViewHeight}];
    _chartView.delegate  = self;
    [self.view addSubview:_chartView];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",_typeUrl,self.cityId,[self.cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[UntilObject getCityId]];
    [SVProgressHUD showWithStatus:nil];
    [_chartView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
}

- (void)changeOrientationAction:(NSNotification *)notification
{
    NSLog(@"得到的参数:%@",notification.object);
    if([notification.object isEqualToString:@"3"])
    {
        //横屏
        _chartView.frame = (CGRect){0,0,_ViewHeight,_ViewWidth};
    }else if([notification.object isEqualToString:@"1"])
    {
        //竖屏
        _chartView.frame = (CGRect){0,0,_ViewWidth,_ViewHeight};
    }
   
    NSLog(@"viewframe的宽: %lf  高: %lf",self.view.frame.size.width,self.view.frame.size.height);
    NSLog(@"viewBound的宽: %lf  高: %lf", self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismissWithError:@"加载失败"];
}

@end
