//
//  WebChartController.h
//  ShanHongProject
//
//  Created by teddy on 15/11/4.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebChartController : UIViewController

@property (nonatomic, strong) NSString *chartType;//图表类型; 1:表示折线图，2:表示柱状图

@property (nonatomic, strong) NSString *titleName;//标题

@property (nonatomic, strong) NSString *cityName;//站点名字

@property (nonatomic, strong) NSString *cityId;

@end
