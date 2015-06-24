//
//  FloodDetailController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/17.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FloodDetailController.h"

@interface FloodDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSArray *listData;
}

@end

@implementation FloodDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
