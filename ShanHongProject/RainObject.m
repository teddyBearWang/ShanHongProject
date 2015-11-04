//
//  RainObject.m
//  ShanHongProject
//
//  Created by teddy on 15/6/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RainObject.h"
#import "UntilObject.h"

//http://115.236.169.28/webserca/Data.ashx?t=GetYqInfo&returntype=json

static  AFHTTPRequestOperation *_operation = nil;
static NSString *_url = nil;
@implementation RainObject

+ (BOOL)fetch:(NSString *)requestType withReaults:(NSString *)type
{
    BOOL ret = NO;
    
    _url = [UntilObject getWebURL];
    //http://115.236.169.28/webserca/Data.ashx?t=GetYqInfo&returntype=json
    NSDictionary *parameter = @{@"t":requestType,@"results":type,@"returntype":@"json"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   // manager.requestSerializer.timeoutInterval = 15; //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation = [manager POST:_url parameters:parameter success:nil failure:nil];
    [_operation waitUntilFinished];
    if (_operation.responseData != nil) {
        ret = YES;
        datas = [NSJSONSerialization JSONObjectWithData:_operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    return ret;
    
}

/*
 *requestType:请求类型
 *result:参数
 *successBlock:成功之后的回调
 *errorBlock； 失败之后的回调
 */
+ (void)fetchWithType:(NSString *)requestType withResult:(NSString *)result success:(void(^)(NSArray *dictArr))successBlock error:(void(^)(void))errorBlock
{
    
    _url = [UntilObject getWebURL];
    //http://115.236.169.28/webserca/Data.ashx?t=GetYqInfo&returntype=json
    NSDictionary *parameter = @{@"t":requestType,@"results":result,@"returntype":@"json"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // manager.requestSerializer.timeoutInterval = 15; //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation = [manager POST:_url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功
        NSArray *list = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        successBlock(list);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败
        errorBlock();
    }];
}


//请求筛选服务
+ (BOOL)fetchFilterData
{
    BOOL ret;
    //http://115.236.169.28/webserca/Data.ashx?t=GetYqInfoSearch&returntype=json
    _url = [UntilObject getWebURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"t":@"GetProjectsSearch",@"returntype":@"json"};
    _operation = [manager POST:_url parameters:parameter success:nil failure:nil];
    [_operation waitUntilFinished];
    if (_operation.responseData != 0) {
        ret = YES;
        datas = [NSJSONSerialization JSONObjectWithData:_operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    return ret;
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
