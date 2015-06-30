//
//  RainObject.m
//  ShanHongProject
//
//  Created by teddy on 15/6/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RainObject.h"

//http://115.236.169.28/webserca/Data.ashx?t=GetYqInfo&returntype=json

static  AFHTTPRequestOperation *_operation = nil;
@implementation RainObject

+ (BOOL)fetch:(NSString *)type
{
    BOOL ret = NO;
    //http://115.236.169.28/webserca/Data.ashx?t=GetYqInfo&returntype=json
    NSDictionary *parameter = @{@"t":type,@"returntype":@"json"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10; //设置超时时间
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation = [manager POST:URL parameters:parameter success:nil failure:nil];
    [_operation waitUntilFinished];
    if (_operation.responseData != nil) {
        ret = YES;
        datas = [NSJSONSerialization JSONObjectWithData:_operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    return ret;
    
}

- (AFHTTPRequestOperation *)getOperation
{
    return _operation;
}


static NSArray *datas = nil;
+ (NSArray *)requestData
{
    return datas;
}

//取消网络请求
+ (void)cancelRequest
{
    if (_operation != nil) {
        [_operation cancel];
    }
}

@end
