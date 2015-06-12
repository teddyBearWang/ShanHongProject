//
//  SiteObject.m
//  ShanHongProject
//
//  Created by teddy on 15/6/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SiteObject.h"
#import "SingleInstanceObject.h"
#import <AFNetworking.h>

@implementation SiteObject

+ (BOOL)fetchSite
{
     BOOL ret = NO;
   // NSURL *url = [NSURL URLWithString:URL];
    /*
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"GetSite" forKey:@"t"];
    request.timeOutSeconds = 15;
    [request setCompletionBlock:^{
        if (request.responseStatusCode == 200) {
            ret = YES;
            NSData *data = request.responseData;
            datas = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startSynchronous];
     */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"t":@"GetSite",
                                @"returntype":@"json"};
    AFHTTPRequestOperation *operation = [manager POST:URL parameters:parameter success:nil failure:nil];
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
