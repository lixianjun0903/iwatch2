//
//  MapViewController.m
//  IWatchII
//
//  Created by mac on 14-11-20.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    
    //地图
    MKMapView*_mapView;
    //定位
    CLLocationManager*_manager;
}
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)GoBack {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"地图";
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    
    //实例化地图
    _mapView=[[MKMapView alloc]initWithFrame:self.view.frame];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    //展现我自己的位置
    _mapView.showsUserLocation=YES;
    
    //开启定位
    _manager=[[CLLocationManager alloc]init];
    _manager.distanceFilter=1000;
    _manager.delegate=self;
    [_manager startUpdatingLocation];
    
    
    
    //逆地理编码
    CLGeocoder*geo=[[CLGeocoder alloc]init];

    //开始逆地理编码
   
    [geo geocodeAddressString:_placeMark completionHandler:^(NSArray *placemarks, NSError *error){
        
        CLPlacemark*mark=[placemarks firstObject];
        
        CLLocation *location =mark.location;
        CLLocationCoordinate2D coord = location.coordinate;
        MKCoordinateSpan span=MKCoordinateSpanMake(0.05, 0.05);
        MKCoordinateRegion region=MKCoordinateRegionMake(coord, span);
        [_mapView setRegion:region];

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = coord;
        annotation.title = _dealerName;
        annotation.subtitle = _placeMark;
        [_mapView addAnnotation:annotation];
    }];
    
    // Do any additional setup after loading the view.
}
//- (MKAnnotationView *)mapView:(MKAnnotationView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
//        
//        
//        MKAnnotationView *newAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.annotation=annotation;
//        newAnnotationView.image = [UIImage imageNamed:@"datouzhen.png"];   //把大头针换成别的图片
//        
//        return newAnnotationView;
//        
//    }
//    return nil;
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
