
//
//  ProjectDetailController.m
//  ShanHongProject
//  ************工情详细******************
//  Created by teddy on 15/6/23.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ProjectDetailController.h"
#import "ProjectObject.h"

@interface ProjectDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *listData;
    UITableView *_table;
}

@end

@implementation ProjectDetailController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [ProjectObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _table = [[UITableView alloc] initWithFrame:(CGRect){0,0,self.view.frame.size.width,self.view.frame.size.height - 64} style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    self.title = [self.Object_dic objectForKey:@"RSNM"];
    
    [self fetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetch
{
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if (<#condition#>) {
//            <#statements#>
//        }
    });
}

- (void)updateUI
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

@end
