//
//  PdfReaderViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/7.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PdfReaderViewController.h"

@interface PdfReaderViewController ()<UIScrollViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation PdfReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"阅读";
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height}];
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(kScreen_Width*2, kScreen_height*2);
    scrollView.maximumZoomScale = 2.0;
    scrollView.minimumZoomScale = 0.5;
    [self.view addSubview:scrollView];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.width)];
    [scrollView addSubview:_webView];
    
    //加载PDF
    [self loadPdfWithDocument:self.pdfName inView:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPdfWithDocument:(NSString *)document inView:(UIWebView *)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:document ofType:@"pdf"];//获取文件的路劲
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //将文件加载到webView上面
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - UIScrollViewDelegate
//放大缩小的时候调用的代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _webView;
}
@end
