//
//  PlanObject.h
//  ShanHongProject
//
//  Created by teddy on 15/7/14.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanObject : NSObject


+ (BOOL)fetchWithType:(NSString *)type level:(NSString *)level sicd:(NSString *)sicd;

+ (NSArray *)requestDatas;

+ (void) cancelRequest;
@end
