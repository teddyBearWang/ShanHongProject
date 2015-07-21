//
//  QiXiangObject.m
//  ShanHongProject
//
//  Created by teddy on 15/6/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "QiXiangObject.h"
#import <AFNetworking.h>
#import "UntilObject.h"

static    AFHTTPRequestOperation *operation = nil;
static NSString *_url = nil;
@implementation QiXiangObject

+ (BOOL)fetchWithType:(NSString *)type
{
    BOOL ret;
    _url = [UntilObject getWebURL];
    //http://115.236.169.28/webserca/Data.ashx?t=GetHtmlSource&results=wxyt$&returntype=json
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"t":@"GetHtmlSource",@"results":type,@"returntype":@"json"};
    operation = [manager POST:_url parameters:parameter success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != 0) {
        ret = YES;
        datas = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    return ret;
}

//下载图片
+ (BOOL)downLoadImages:(NSString *)image_url
{
    BOOL ret;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    operation = [manager POST:image_url parameters:nil success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != 0) {
        ret = YES;
        img_data = operation.responseData;//将图片数据穿出
    }
    return ret;
}

//返回NSData类型数据
static NSData *img_data;
+ (NSData *)requestData
{
    return img_data;
}

static NSArray *datas = nil;
+ (NSArray *)requestDatas
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
