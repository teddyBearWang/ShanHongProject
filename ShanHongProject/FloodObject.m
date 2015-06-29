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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"t":@"GetTodayList",@"returntype":@"json"};
    operation = [manager POST:URL parameters:parameter success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != 0) {
        ret = YES;
        data = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
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
