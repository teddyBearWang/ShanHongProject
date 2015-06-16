//
//  WaterViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterViewController.h"
#import "SVProgressHUD.h"
#import "WaterCell.h"
#import "RainObject.h"
#import "CustomHeaderView.h"

@interface WaterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;//数据源
    BOOL ret;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation WaterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //强制屏幕横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实时水情";
    

    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 44;
    
    [self refresh:@"GetSqInfo"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //用户点击返回,取消用户请求
        [RainObject cancelRequest];
    }
}

- (void)refresh:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RainObject fetch:type]) {
            //更新UI
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败~"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        ret = YES;
        listData = [RainObject requestData];
        [self.myTableView reloadData];
    });
}
#pragma mark - UITableViewDataSOurce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(ret)
    {
        //有数据的时候
        WaterCell *cell = (WaterCell *)[tableView dequeueReusableCellWithIdentifier:@"WaterCell"];
        if (cell == nil) {
            cell = (WaterCell *)[[[NSBundle mainBundle] loadNibNamed:@"WaterCell" owner:self options:nil] lastObject];
        }
        NSDictionary *dic = [listData objectAtIndex:indexPath.row];
        cell.stationName.text = [[dic objectForKey:@"stnm"] isEqual:@""] ? @"--" : [dic objectForKey:@"stnm"];
        cell.lastestLevel.text = [[dic objectForKey:@"new"] isEqual:@""] ? @"--" : [dic objectForKey:@"new"];
        cell.warnWater.text = [[dic objectForKey:@"max"] isEqual:@""] ? @"--" : [dic objectForKey:@"max"];
        return cell;
    }else{
        //无数据
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *view = [[CustomHeaderView alloc] initWithFirstLabel:@"测站" withSecond:@"最新(m)" withThree:@"超警(m)"];
    view.backgroundColor = BG_COLOR;
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

@end
