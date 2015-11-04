//
//  RainObject.h
//  ShanHongProject
//  *********雨情数据***********
//  Created by teddy on 15/6/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface RainObject : NSObject

+ (BOOL)fetch:(NSString *)requestType withReaults:(NSString *)type;

/*
 *requestType:请求类型
 *result:参数
 *successBlock:成功之后的回调
 *errorBlock； 失败之后的回调
 */
+ (void)fetchWithType:(NSString *)requestType withResult:(NSString *)result success:(void(^)(NSArray *dictArr))successBlock error:(void(^)(void))errorBlock;

+ (NSArray *)requestData;

+ (void)cancelRequest;

@end
