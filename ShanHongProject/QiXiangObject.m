//
//  QiXiangObject.m
//  ShanHongProject
//
//  Created by teddy on 15/6/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "QiXiangObject.h"
#import <AFNetworking.h>

static    AFHTTPRequestOperation *operation = nil;
@implementation QiXiangObject

+ (BOOL)fetchWithType:(NSString *)type
{
    BOOL ret;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"t":@"GetHtmlSource",@"results":type,@"returntype":@"json"};
    operation = [manager POST:URL parameters:parameter success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != 0) {
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

+ (void)cancelRequest
{
    if (operation != nil) {
        [operation cancel];
    }
}

@end
