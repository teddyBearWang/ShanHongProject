//
//  StationSelectController.h
//  ShanHongProject
//
//  Created by teddy on 15/6/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectStationDelegate <NSObject>

- (void)selectStationAction:(NSString *)area;

@end

@interface StationSelectController : UIViewController

@property (nonatomic, assign) id<selectStationDelegate>delegate;

@end
