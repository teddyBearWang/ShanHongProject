//
//  ProjectObject.h
//  ShanHongProject
//
//  Created by teddy on 15/6/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectObject : NSObject

+ (BOOL)fetch:(NSString *)type withProject:(NSString *)project;

+ (NSArray *)requestData;

+ (void)cancelRequest;
@end
