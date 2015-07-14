//
//  LoginToken.m
//  ShanHongProject
//
//  Created by teddy on 15/7/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "LoginToken.h"
#import <AFNetworking.h>

static AFHTTPRequestOperation *operation;
@implementation LoginToken


+ (BOOL)fetchWithUserName:(NSString *)name Psw:(NSString *)psw Version:(NSString *)version CityName:(NSString *)city
{
    //http://115.236.169.28/webserca/Data.ashx?t=Login&results=dcxxadmin$123456$1.1.2$淳安&returntype=json
    BOOL ret = NO;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *user = [NSString stringWithFormat:@"%@$%@$%@$%@",name,psw,version,city];
    NSDictionary *paramters = @{@"t":@"Login",
                                @"results":user,
                                @"returntype":@"json"};
    operation = [manager POST:URL parameters:paramters success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != nil) {
        ret = YES;
        datas = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return ret;
}

static NSArray *datas = nil;
+ (NSArray *)requestDatas
{
    return datas;
}
@end
