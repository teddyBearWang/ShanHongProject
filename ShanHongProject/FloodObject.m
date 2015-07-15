//
//  FloodObject.m
//  ShanHongProject
//
//  Created by teddy on 15/6/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FloodObject.h"
#import "SVProgressHUD.h"
#import <AFNetworking.h>

AFHTTPRequestOperation *operation = nil;
@implementation FloodObject

+ (BOOL)fetch
{
    BOOL ret;
    //http://115.236.169.28/webserca/Data.ashx?t=GetTodayList&returntype=json
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"t":@"GetTodayList",@"returntype":@"json"};
    operation = [manager POST:URL parameters:parameter success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != nil) {
        ret = YES;
        data = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return ret;
}

////获取汛情详情
+ (BOOL)fetchWithType:(NSString *)type
{
    BOOL ret = NO;
   // http://115.236.169.28/webserca/Data.ashx?t=GetTodayView&results=yl&returntype=json
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"t":@"GetTodayView",
                                @"results":type,
                                @"returntype":@"json"};
    if (operation != nil) {
        operation = nil;
    }
    if (data != nil) {
        data = nil;
    }
    operation = [manager POST:URL parameters:parameter success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != nil) {
        ret = YES;
        data = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
       
    }
    return ret;
}

static NSArray *data = nil;
+ (NSArray *)requestData
{
    return data;
}

+ (void)cancelRequest
{
    if (operation != nil) {
        [operation cancel];
    }
}

@end
