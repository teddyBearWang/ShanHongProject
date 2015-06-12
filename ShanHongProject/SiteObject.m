//
//  SiteObject.m
//  ShanHongProject
//
//  Created by teddy on 15/6/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SiteObject.h"
#import "ASIFormDataRequest.h"
#import "SingleInstanceObject.h"

@implementation SiteObject

+ (BOOL)fetchSite
{
    __block BOOL ret = NO;
    NSURL *url = [NSURL URLWithString:URL];
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
    return ret;
}

static NSArray *datas = nil;
+ (NSArray *)requestDatas
{
    return datas;
}

@end
