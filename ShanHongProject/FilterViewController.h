//
//  FilterViewController.h
//  ShanHongProject
//
//  Created by teddy on 15/6/17.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UITableViewController
{
    NSArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}

@end
