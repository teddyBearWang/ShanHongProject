//
//  RainObject.m
//  ShanHongProject
//
//  Created by teddy on 15/6/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RainObject.h"
#import <AFNetworking.h>

//http://115.236.169.28/webserca/Data.ashx?t=GetYqInfo&returntype=json

@implementation RainObject

+ (BOOL)fetch:(NSString *)type
{
    BOOL ret = NO;
    NSDictionary *parameter = @{@"t":type,@"returntype":@"json"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10; //设置超时时间
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [manager POST:URL parameters:parameter success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != nil) {
        ret = YES;
        datas = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    return ret;
}


static NSArray *datas = nil;
+ (NSArray *)requestData
{
    return datas;
}

@end
