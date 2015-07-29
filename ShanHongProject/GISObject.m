//
//  GISObject.m
//  ShanHongProject
//
//  Created by teddy on 15/7/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "GISObject.h"
#import <AFNetworking.h>
#import "UntilObject.h"

static AFHTTPRequestOperation *operation = nil;
@implementation GISObject

+ (BOOL)fetch
{
    BOOL ret = NO;
    //http://115.236.169.28/webserca/data.ashx?&t=GetGisInfo&returntype=json
    NSString *_url = [UntilObject getWebURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"t":@"GetGisInfo",
                                 @"returntype":@"json"};
    operation = [manager POST:_url parameters:parameters success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != nil) {
        ret = YES;
        NSLog(@"解析到得数据：%@",operation.responseString);

        data = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"解析到得数据：%@",data);
    }
    return ret;
}

static NSArray *data;
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
