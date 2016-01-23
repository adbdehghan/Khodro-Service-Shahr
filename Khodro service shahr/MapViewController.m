//
//  MapViewController.m
//  Khodro service shahr
//
//  Created by aDb on 1/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "MapViewController.h"
@import GoogleMaps;

@interface MapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MapViewController
{
      GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.6961
                                                            longitude:51.4231
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    //Controls the type of map tiles that should be displayed.

    
    //Shows the compass button on the map
    mapView_.settings.compassButton = YES;
    
    //Shows the my location button on the map
    mapView_.settings.myLocationButton = YES;
    
    self.view = mapView_;
    
    // Creates a marker in the center of the map.

    
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:15.0];
    
    [mapView_ animateToCameraPosition:camera];
    
    
    [self.locationManager stopUpdatingLocation];
    
    for (int i=0; i<1; i++) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude -[self generateRandomNumberWithlowerBound:0 upperBound:.1], location.coordinate.longitude + [self generateRandomNumberWithlowerBound:0 upperBound:.1]);
        marker.title = @"1";
        marker.snippet = @"20";
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.icon = [UIImage imageNamed:@"annotationPin"];
        marker.map = mapView_;
    }
    

}

-(float) generateRandomNumberWithlowerBound:(float)from
                               upperBound:(float)to
{
   return (((float)arc4random()/0x100000000)*(to-from)+from);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
