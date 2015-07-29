//
//  ContactObject.m
//  ShanHongProject
//
//  Created by teddy on 15/7/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ContactObject.h"
#import <AFNetworking.h>
#import "UntilObject.h"

static AFHTTPRequestOperation *_operation = nil;
@implementation ContactObject


+ (BOOL)fetch:(NSString *)results
{
    BOOL ret;
    NSString *url = [UntilObject getWebURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parmater = @{@"t":@"GetAdcdAdress2",
                               @"results":results,
                               @"returntype":@"json"};
    _operation = [manager POST:url parameters:parmater success:nil failure:nil];
    [_operation waitUntilFinished];
    if (_operation.responseData != nil) {
        ret = YES;
        data = [NSJSONSerialization JSONObjectWithData:_operation.responseData options:NSJSONReadingMutableContainers error:nil];
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
    if (_operation != nil) {
        [_operation cancel];
    }
}
@end
