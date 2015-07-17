//
//  CustomCalloutView.m
//  ShanHongProject
//
//  Created by teddy on 15/7/17.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "CustomCalloutView.h"

@implementation CustomCalloutView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1.0;
        
    }
    return self;
    
}


@end
