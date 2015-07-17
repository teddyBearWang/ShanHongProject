//
//  GISViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "GISViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "SingleInstanceObject.h"
#import "GISObject.h"
#import "SVProgressHUD.h"
#import "CustomAnnotation.h"
#import "FilterViewController.h"
#import "SelectViewController.h"
#import "StationType.h"
#import "CustomCalloutView.h"
#import "FilterViewController.h"

//右边barItemView的宽度
#define RIGHTVIEWWIDTH 80
//右边barItemView的高度
#define RIGHTVIEWHEIHGT 30

@interface GISViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapVIew;
    NSArray *_sourceDatas; //元数据
    NSMutableArray *_filterDatas; //筛选数据(显示数据)
    SingleInstanceObject *_segton;//单例对象
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GISViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //取消
        [GISObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"GIS应用";
    
    [self initNavigationBar];
    
    //初始化单例，并将默认显示的类型设置为"水位站"
    _segton = [SingleInstanceObject defaultInstance];
    StationType *station = [[StationType alloc] init];
    station.title = @"水位站";
    station.type = @"sw";
    station.imageName = @"1";
    _segton.selectArray = [NSMutableArray arrayWithObject:station];
    
    _filterDatas = [NSMutableArray array];
    
    //筛选返回触发通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowSingleStationAction:) name:KTapStationNotification object:nil];
    
    
    //开始加载网络数据
    [self getStationInfo];
}

- (void)initNavigationBar
{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,RIGHTVIEWHEIHGT*2,RIGHTVIEWHEIHGT}];
    view.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.frame = (CGRect){0,0,RIGHTVIEWHEIHGT,RIGHTVIEWHEIHGT};
    [filterBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [filterBtn setImage:[UIImage imageNamed:@"select_click"] forState:UIControlStateHighlighted];
    [filterBtn addTarget:self action:@selector(filterStationAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:filterBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = (CGRect){RIGHTVIEWHEIHGT,0,RIGHTVIEWHEIHGT,RIGHTVIEWHEIHGT};
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"search_click"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchStationAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchBtn];
}

#pragma mark - private Method
- (void)filterStationAction
{
    SelectViewController *select = [[SelectViewController alloc] init];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    [select returnSelects:^(NSArray *selects) {
        //原本存在数值，则删除
        if (_filterDatas.count != 0) {
            [_filterDatas removeAllObjects];
        }
        //筛选数据
        [self filterSourceData];
        
        //现将原本地图上的移除
        [_mapVIew removeAnnotations:_mapVIew.annotations];
        
        //重新添加标注视图
        [self addAnnotationForMapView];
        
    }];
    [self.navigationController pushViewController:select animated:YES];
}

//进入到搜索界面
- (void)searchStationAction
{
    FilterViewController *filter = [[FilterViewController alloc] init];
    filter.data = _sourceDatas;//数据源
    filter.filterType = GISFilter;
    filter.title_name = @"站点搜索";
    [self.navigationController pushViewController:filter animated:YES];
}

//创建地图
- (void)createMapView
{
    //取出本地文件
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [user objectForKey:STATION];
    
    _mapVIew = [[MAMapView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height}];
    _mapVIew.mapType = MAMapTypeSatellite;
    _mapVIew.delegate = self;
    _mapVIew.showsScale = NO;//不显示比例尺
    _mapVIew.showsCompass = NO;//不显示罗盘
    [self.view addSubview:_mapVIew];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[userDic objectForKey:@"ScenterLat"] floatValue], [[userDic objectForKey:@"ScenterLng"] floatValue]);
    _mapVIew.centerCoordinate = coordinate;
    
    [self addAnnotationForMapView];
    
}
#pragma mark - loadMap Private Method
//生成标注点
- (NSMutableArray *)addAnnotation
{
    NSMutableArray *annotations = [NSMutableArray array];
    for (int i=0; i<_filterDatas.count; i++) {
        NSDictionary *dic = [_filterDatas objectAtIndex:i];
        //首先判断不为空
        if ([[dic objectForKey:@"X"] isEqualToString:@""] && [[dic objectForKey:@"X"] isEqualToString:@""]) {
            continue;
        }else{
            //再次判断不全为0
            if ([[dic objectForKey:@"X"] floatValue] != 0 || [[dic objectForKey:@"Y"] floatValue] != 0) {
                CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"Y"] floatValue], [[dic objectForKey:@"X"] floatValue]);
                annotation.type = [dic objectForKey:@"MyType"];
                [annotations addObject:annotation];
                //默认将气泡弹出
              //  [_mapVIew selectAnnotation:annotation animated:YES];
            }
            
        }
    }
    
    [_segton.selectArray removeAllObjects];//清除单例中保存的
    
    return annotations;
}

//添加标注视图到地图上
- (void)addAnnotationForMapView
{
    //添加标注到地图上
    NSArray *annotations = (NSArray *)[self addAnnotation];
    [_mapVIew addAnnotations:annotations];
}


#pragma mark - Private

- (void)getStationInfo
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([GISObject fetch]) {
            //updateUI
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        _sourceDatas = [GISObject requestData];
        [self filterSourceData];
        
        [self createMapView];
        });
    
}

//删选数据
- (void)filterSourceData
{
    NSArray *array = [NSArray array];
    for (int i=0; i<_segton.selectArray.count; i++) {
        StationType *station = _segton.selectArray[i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"MyType",station.type];
        //传递进来的谓词，筛选数据
        NSArray *filters = [_sourceDatas filteredArrayUsingPredicate:predicate];
       array = (NSMutableArray *)[array arrayByAddingObjectsFromArray:filters];
        
    }
    
    _filterDatas = [NSMutableArray arrayWithArray:array];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//显示单个站点
- (void)ShowSingleStationAction:(NSNotification *)notification
{
    //全部移除原来的
    [_mapVIew removeAnnotations:_mapVIew.annotations];
    NSDictionary *dic = (NSDictionary *)notification.object;
    //再次判断不全为0
    CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"Y"] floatValue], [[dic objectForKey:@"X"] floatValue]);
    annotation.type = [dic objectForKey:@"MyType"];
    [_mapVIew addAnnotation:annotation];
            //默认将旗袍弹出
    [_mapVIew selectAnnotation:annotation animated:YES];
}


#pragma mark - MAMapViewDelegate
/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    CustomAnnotation *ann = (CustomAnnotation *)annotation;
    
    if ([ann isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *identifer = @"Annotation";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] init];
        }
        annotationView.calloutOffset = CGPointMake(5, 0);//向右偏移
        annotationView.canShowCallout = NO;//弹出自定义气泡
        if ([ann.type isEqualToString:@"sw"])
        {
            annotationView.image = [UIImage imageNamed:@"1"];
        }
        else if ([ann.type isEqualToString:@"yl"]){
            annotationView.image = [UIImage imageNamed:@"2"];
        }
        else if ([ann.type isEqualToString:@"sk"])
        {
            annotationView.image = [UIImage imageNamed:@"3"];
        }
        else if ([ann.type isEqualToString:@"sz"])
        {
            annotationView.image = [UIImage imageNamed:@"4"];
        }
        else if ([ann.type isEqualToString:@"df"])
        {
            annotationView.image = [UIImage imageNamed:@"5"];
        }
        else if ([ann.type isEqualToString:@"sdz"])
        {
            annotationView.image = [UIImage imageNamed:@"6"];
        }
        else
        {
            annotationView.image = [UIImage imageNamed:@"7"];
            
        }
        
        return annotationView;
    }
   
    return nil;
}

//创建气泡视图
- (UIView *)createCallOutView:(CustomAnnotation *)annotation
{
    CustomCalloutView *callout = (CustomCalloutView *)[[[NSBundle mainBundle] loadNibNamed:@"CalloutView" owner:nil options:nil] lastObject];
    
    if ([annotation.type isEqualToString:@"sw"])
    {
        //水位站
        
        callout.stationlabel.text = @"雨量测站:";
        callout.levelLabel.text = @"1h雨量:";
    }
    else if ([annotation.type isEqualToString:@"yl"])
    {
        //雨量站
    }
    else if ([annotation.type isEqualToString:@"sk"])
    {
        //水库站
    }
    else if ([annotation.type isEqualToString:@"sz"])
    {
        //水闸
    }
    else if ([annotation.type isEqualToString:@"df"])
    {
     //堤防
    }
    else if ([annotation.type isEqualToString:@"sdz"])
    {
     //水电站
    }
    else
    {
        
        //山塘
    }
    
    return callout;
}


@end
