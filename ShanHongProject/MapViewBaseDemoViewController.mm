//
//  MapViewBaseDemoViewController.m
//  BaiduMapSdkSrc
//
//  Created by BaiduMapAPI on 13-7-24.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "MapViewBaseDemoViewController.h"

@interface MapViewBaseDemoViewController()<UIGestureRecognizerDelegate>
    

@end

@implementation MapViewBaseDemoViewController
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [_mapView setMapType:BMKMapTypeSatellite];
    
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(35.718, 111.581)];
    [self.view addSubview:_mapView];
    
    [self showAnnotations];
    
    [self addCustomGestures];//添加自定义的手势
}



-(void)showAnnotations{

    BMKPointAnnotation* animatedAnnotation1 = [[BMKPointAnnotation alloc]init];
    animatedAnnotation1.coordinate = CLLocationCoordinate2DMake(35.788, 111.631);
    animatedAnnotation1.title = @"111111111";
    animatedAnnotation1.subtitle = @"sadf";
    [_mapView addAnnotation:animatedAnnotation1];
    
    BMKPointAnnotation* animatedAnnotation2 = [[BMKPointAnnotation alloc]init];
    animatedAnnotation2.coordinate = CLLocationCoordinate2DMake(35.768, 111.551);
    animatedAnnotation2.title = @"2222222";
    [_mapView addAnnotation:animatedAnnotation2];
    
    BMKPointAnnotation* animatedAnnotation3 = [[BMKPointAnnotation alloc]init];
    animatedAnnotation3.coordinate = CLLocationCoordinate2DMake(35.718, 111.611);
    animatedAnnotation3.title = @"333333333";
    [_mapView addAnnotation:animatedAnnotation3];
}



-(void)viewWillDisappear:(BOOL)animated {
//    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
//    if (_mapView) {
//        _mapView = nil;
//    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //BMKMapView控件初始化完成
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}


- (void)addCustomGestures {

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    
    [self.view addGestureRecognizer:doubleTap];
    

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delaysTouchesEnded = NO;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap {

    NSLog(@"my handleSingleTap");
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {

    NSLog(@"my handleDoubleTap");
}

@end
