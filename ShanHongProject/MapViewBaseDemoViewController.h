//
//  MapViewBaseDemoViewController.h
//  BaiduMapSdkSrc
//
//  Created by BaiduMapAPI on 13-7-24.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>


@interface MapViewBaseDemoViewController :  UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate> {
    IBOutlet BMKMapView* _mapView;
    
}
@end
