//
//  RainCell.h
//  ZDWater2
//
//  Created by teddy on 15/6/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stationName;//测站名字
@property (weak, nonatomic) IBOutlet UILabel *oneHour;
@property (weak, nonatomic) IBOutlet UILabel *threeHour;
@property (weak, nonatomic) IBOutlet UILabel *today;

@end
