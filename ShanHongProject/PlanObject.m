//
//  PlanObject.m
//  ShanHongProject
//
//  Created by teddy on 15/7/14.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PlanObject.h"
#import <AFNetworking.h>

static AFHTTPRequestOperation *operation = nil;
@implementation PlanObject


+ (BOOL)fetchWithType:(NSString *)type level:(NSString *)level sicd:(NSString *)sicd
{
    BOOL ret = NO;
    //http://115.236.169.28/webserca/data.ashx?&t=GetFxPlanTree&results=name$0$$false&returntype=json
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *str = [NSString stringWithFormat:@"name$%@$%@$false",level,sicd];
    NSDictionary *parameters = @{@"t":type,
                                 @"results":str,
                                 @"returntype":@"json"};
    operation = [manager POST:URL parameters:parameters success:nil failure:nil];
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

+ (void) cancelRequest
{
    if (operation != nil) {
        [operation cancel];
    }
}

@end
