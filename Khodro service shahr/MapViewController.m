//
//  MapViewController.m
//  Khodro service shahr
//
//  Created by aDb on 1/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "MapViewController.h"
#import "DataDownloader.h"
#import "MapPlace.h"
#import "LRouteController.h"
#import "SMCalloutView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIWindow+YzdHUD.h"

#define SCREEN_HEIGHT_WITHOUT_STATUS_BAR     [[UIScreen mainScreen] bounds].size.height - 60
#define SCREEN_WIDTH                         [[UIScreen mainScreen] bounds].size.width
#define HEIGHT_STATUS_BAR                    60
#define Y_DOWN_TABLEVIEW                     SCREEN_HEIGHT_WITHOUT_STATUS_BAR - 60
#define DEFAULT_HEIGHT_HEADER                140.0f
#define MIN_HEIGHT_HEADER                    10.0f
#define DEFAULT_Y_OFFSET                     ([[UIScreen mainScreen] bounds].size.height == 480.0f) ? -200.0f : -250.0f
#define FULL_Y_OFFSET                        -200.0f
#define MIN_Y_OFFSET_TO_REACH                -30
#define OPEN_SHUTTER_LATITUDE_MINUS          0
#define CLOSE_SHUTTER_LATITUDE_MINUS         230

@import GoogleMaps;
static const CGFloat CalloutYOffset = 50.0f;
@interface MapViewController () <CLLocationManagerDelegate,UIGestureRecognizerDelegate,GMSMapViewDelegate>
@property (strong, nonatomic)   UITapGestureRecognizer  *tapMapViewGesture;
@property (strong, nonatomic)   UITapGestureRecognizer  *tapTableViewGesture;
@property (nonatomic)           CGRect                  headerFrame;
@property (nonatomic)           float                   headerYOffSet;
@property (nonatomic)           BOOL                    isShutterOpen;
@property (nonatomic)           BOOL                    displayMap;
@property (nonatomic)           float                   heightMap;
@property (nonatomic)           CLLocation              *myLocation;
@property (nonatomic)           CLLocation              *deviceLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) DataDownloader *getData;

@property (nonatomic, strong) NSMutableArray *placesCopy;
@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;
@end
static NSString *const ServerURL = @"http://khodroservice.kara.systems";
@implementation MapViewController
{
      GMSMapView *mapView;
    NSMutableArray *_coordinates;
    
    LRouteController *_routeController;
    GMSPolyline *_polyline;
    GMSMarker *_markerStart;
    GMSMarker *_markerFinish;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupTableView];
    [self setupMapView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m

    _coordinates = [NSMutableArray new];
    _routeController = [LRouteController new];
    
    _markerStart = [GMSMarker new];
    _markerStart.title = @"Start";
    
    _markerFinish = [GMSMarker new];
    _markerFinish.title = @"Finish";
    
    self.calloutView = [[SMCalloutView alloc] init];
    self.calloutView.hidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(0,0,45,42);
    button.backgroundColor = [UIColor colorWithRed:39/255.f green:139/255.f blue:243/255.f alpha:1];
    UIImage *buttonImage = [UIImage imageNamed:@"carNavi"];
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    self.calloutView.rightAccessoryView = button;
    
    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
    

    self.places = [[NSMutableArray alloc]init];
    NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,self.categoryURL];
    
    UIImageView *markerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
   // [markerImage setImageWithURL:[NSURL URLWithString:fullURL]
     //                       placeholderImage:[UIImage imageNamed:@"annotationPin"] options:SDWebImageRefreshCached usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)UIActivityIndicatorViewStyleGray];
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                MapPlace *place = [MapPlace modelFromJSONDictionary:item];
                [self.places addObject:place];
                

                GMSMarker *marker = [[GMSMarker alloc] init];
            
                marker.position = CLLocationCoordinate2DMake([place.Lat doubleValue],[place.Lng doubleValue]);
                marker.title = place.Title;
                marker.snippet = @"";
                marker.appearAnimation = kGMSMarkerAnimationPop;
                marker.icon =[UIImage imageNamed:@"marker.png"]; //markerImage.image;
                marker.map = mapView;
                
            }

            self.placesCopy = [self.places mutableCopy];
            [self.locationManager startUpdatingLocation];
            
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"خب"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };




    
    if (self.searchplaces.count> 0 ) {
        for (MapPlace *place in self.searchplaces) {
            
            
            
            
            GMSMarker *marker = [[GMSMarker alloc] init];
            
            marker.position = CLLocationCoordinate2DMake([place.Lat doubleValue],[place.Lng doubleValue]);
            marker.title = place.Title;
            marker.snippet = @"";
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.icon =[UIImage imageNamed:@"marker.png"]; //markerImage.image;
            marker.map = mapView;
            
        }
        
        self.placesCopy = [self.searchplaces mutableCopy];
        self.places = [self.searchplaces mutableCopy];
        [self.locationManager startUpdatingLocation];
        
    }
    else{
        [self.getData GetCategoryLocations:self.categoryID withCallback:callback];
    }
    
    
    // Creates a marker in the center of the map.

    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.categoryName;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    
    barButtonItem.tintColor = [UIColor whiteColor];
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
}


-(void)getDirection
{
    _polyline.map = nil;
    _markerStart.map = nil;
    _markerFinish.map = nil;
    [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
    
    [_routeController getPolylineWithLocations:_coordinates travelMode:TravelModeDriving andCompletitionBlock:^(GMSPolyline *polyline, NSError *error) {
        
        [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        else if (!polyline)
        {
            NSLog(@"No route");
            [_coordinates removeAllObjects];
        }
        else
        {
            _markerStart.position = [[_coordinates objectAtIndex:0] coordinate];
          //  _markerStart.map = mapView;
            
            _markerFinish.position = [[_coordinates lastObject] coordinate];
           // _markerFinish.map = mapView;
            
            _polyline = polyline;
            _polyline.strokeWidth = 8;
            _polyline.strokeColor = [UIColor colorWithRed:39/255.f green:139/255.f blue:243/255.f alpha:1];
            _polyline.map = mapView;
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.deviceLocation.coordinate.latitude
                                                                    longitude:self.deviceLocation.coordinate.longitude
                                                                         zoom:18.0];
            [mapView animateToCameraPosition:camera];
        }
    }];


}

- (void)mapView:(GMSMapView *)pMapView didChangeCameraPosition:(GMSCameraPosition *)position {
    /* move callout with map drag */
    if (pMapView.selectedMarker != nil && !self.calloutView.hidden) {
        CLLocationCoordinate2D anchor = [pMapView.selectedMarker position];
        
        CGPoint arrowPt = self.calloutView.backgroundView.arrowPoint;
        
        CGPoint pt = [pMapView.projection pointForCoordinate:anchor];
        pt.x -= arrowPt.x;
        pt.y -= arrowPt.y + CalloutYOffset;
        
        self.calloutView.frame = (CGRect) {.origin = pt, .size = self.calloutView.frame.size };
    } else {
        self.calloutView.hidden = YES;
    }
}

- (void)calloutAccessoryButtonTapped:(id)sender {
    if (mapView.selectedMarker) {
        GMSMarker *marker = mapView.selectedMarker;
        //NSDictionary *userData = marker.userData;

        [_coordinates removeAllObjects];
        
        [_coordinates addObject:self.deviceLocation];
        [_coordinates addObject:[[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude]];
    
        
        [self getDirection];
    }
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    CLLocationCoordinate2D anchor = marker.position;
    
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
    
    self.calloutView.title = marker.title;
    
    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
    
    self.calloutView.hidden = NO;
    
    CGRect calloutRect = CGRectZero;
    calloutRect.origin = point;
    calloutRect.size = CGSizeZero;
    
    [self.calloutView presentCalloutFromRect:calloutRect
                                      inView:mapView
                           constrainedToView:mapView
                                    animated:YES];
    
    return self.emptyCalloutView;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.calloutView.hidden = YES;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    /* don't move map camera to center marker on tap */
    mapView.selectedMarker = marker;
    return YES;
}

-(void)setup{
    _heighTableViewHeader       = DEFAULT_HEIGHT_HEADER;
    _heighTableView             = SCREEN_HEIGHT_WITHOUT_STATUS_BAR;
    _minHeighTableViewHeader    = MIN_HEIGHT_HEADER;
    _default_Y_tableView        = HEIGHT_STATUS_BAR;
    _Y_tableViewOnBottom        = Y_DOWN_TABLEVIEW;
    _minYOffsetToReach          = MIN_Y_OFFSET_TO_REACH;
    _latitudeUserUp             = CLOSE_SHUTTER_LATITUDE_MINUS;
    _latitudeUserDown           = OPEN_SHUTTER_LATITUDE_MINUS;
    _default_Y_mapView          = DEFAULT_Y_OFFSET;
    _headerYOffSet              = DEFAULT_Y_OFFSET;
    _heightMap                  = 1000.0f;
    _regionAnimated             = YES;
    _userLocationUpdateAnimated = YES;
}

-(void)setupMapView{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.6961
                                                            longitude:51.4231
                                                                 zoom:11];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, self.heighTableView) camera:camera];
    
    mapView.myLocationEnabled = YES;
    //Controls the type of map tiles that should be displayed.
    
    
    //Shows the compass button on the map
    mapView.settings.compassButton = YES;
    
    //Shows the my location button on the map
    mapView.settings.myLocationButton = YES;
    mapView.delegate = self;
    
//    self.view = mapView;
    

    [self.view insertSubview:mapView belowSubview: self.tableView];
    
    
    
}

-(void)setupTableView{
    self.tableView                  = [[UITableView alloc]  initWithFrame: CGRectMake(0, 60, SCREEN_WIDTH, self.heighTableView)];
    self.tableView.tableHeaderView  = [[UIView alloc]       initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.heighTableViewHeader)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    // Add gesture to gestures
    self.tapMapViewGesture      = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTapMapView:)];
    self.tapTableViewGesture    = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTapTableView:)];
    self.tapTableViewGesture.delegate = self;
    [self.tableView.tableHeaderView addGestureRecognizer:self.tapMapViewGesture];
    [self.tableView addGestureRecognizer:self.tapTableViewGesture];
    
    // Init selt as default tableview's delegate & datasource
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    [self.view addSubview:self.tableView];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    self.myLocation = location;
    self.deviceLocation = location;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.myLocation.coordinate.latitude
                                                            longitude:self.myLocation.coordinate.longitude
                                                                 zoom:11.0];
    [mapView animateToCameraPosition:camera];

    [self performSelector:@selector(ScrollUpMap:) withObject:[NSNumber numberWithFloat:self.latitudeUserUp] afterDelay:.25];
    
    [self.locationManager stopUpdatingLocation];
    
    for (MapPlace *place in self.placesCopy) {
        
        CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[place.Lat doubleValue] longitude:[place.Lng doubleValue]];
        
        
        CLLocationDistance distance = [LocationAtual distanceFromLocation:self.myLocation];
        
        NSNumber* num = [NSNumber numberWithFloat:distance];
        
        
        
      //  place.distance = [NSNumber numberWithFloat: [self directMetersFromCoordinate:self.myLocation.coordinate toCoordinate:CLLocationCoordinate2DMake([place.Lat doubleValue], [place.Lng doubleValue])]];
        place.distance = num;

        
     //   self.places = self.placesCopy;
        

    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    [self.placesCopy sortUsingDescriptors:@[sortDescriptor]];
    self.places = self.placesCopy;
    [self.tableView reloadData];
}



- (CGFloat)directMetersFromCoordinate:(CLLocationCoordinate2D)from toCoordinate:(CLLocationCoordinate2D)to {
    
    static const double DEG_TO_RAD = 0.017453292519943295769236907684886;
    static const double EARTH_RADIUS_IN_METERS = 6372797.560856;
    
    double latitudeArc  = (from.latitude - to.latitude)* DEG_TO_RAD;
    double longitudeArc = (from.longitude - to.longitude) * DEG_TO_RAD;
    //    return  sqrt(fabsf((latitudeArc*latitudeArc)-(longitudeArc*longitudeArc)));
    double latitudeH = sin(latitudeArc * 0.5);
    latitudeH *= latitudeH;
    double lontitudeH = sin(longitudeArc * 0.5);
    lontitudeH *= lontitudeH;
    double tmp = cos(from.latitude*DEG_TO_RAD) * cos(to.latitude*DEG_TO_RAD);
    return EARTH_RADIUS_IN_METERS * 2.0 * asin(sqrt(latitudeH + tmp*lontitudeH));
}

#pragma mark - Internal Methods

- (void)handleTapMapView:(UIGestureRecognizer *)gesture {
    if(!self.isShutterOpen){
        // Move the tableView down to let the map appear entirely
        [self openShutter];
        // Inform the delegate
        if([self.delegate respondsToSelector:@selector(didTapOnMapView)]){
            [self.delegate didTapOnMapView];
        }
    }
}

- (void)handleTapTableView:(UIGestureRecognizer *)gesture {
    if(self.isShutterOpen){
        // Move the tableView up to reach is origin position
        [self closeShutter];
        // Inform the delegate
        if([self.delegate respondsToSelector:@selector(didTapOnTableView)]){
            [self.delegate didTapOnTableView];
        }
    }
}

// Move DOWN the tableView to show the "entire" mapView
-(void) openShutter{
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.tableView.tableHeaderView     = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.minHeighTableViewHeader)];
                         mapView.frame                 = CGRectMake(0, FULL_Y_OFFSET, mapView.frame.size.width, self.heightMap);
                         self.tableView.frame               = CGRectMake(0, self.Y_tableViewOnBottom, self.tableView.frame.size.width, self.tableView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         // Disable cells selection
                         [self.tableView setAllowsSelection:NO];
                         self.isShutterOpen = YES;
                         [self.tableView setScrollEnabled:NO];
                         // Center the user 's location
                         [self zoomToUserLocation:mapView.myLocation
                                      minLatitude:self.latitudeUserDown
                                         animated:self.regionAnimated];
                         
                         // Inform the delegate
                         if([self.delegate respondsToSelector:@selector(didTableViewMoveDown)]){
                             [self.delegate didTableViewMoveDown];
                         }
                     }];
}

// Move UP the tableView to get its original position
-(void) closeShutter{
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         mapView.frame             = CGRectMake(0, 60, mapView.frame.size.width, self.heighTableView);
                         self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.headerYOffSet, self.view.frame.size.width, self.heighTableViewHeader)];
                         self.tableView.frame           = CGRectMake(0, 60, self.tableView.frame.size.width, self.tableView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         // Enable cells selection
                         [self.tableView setAllowsSelection:YES];
                         self.isShutterOpen = NO;
                         [self.tableView setScrollEnabled:YES];
                         [self.tableView.tableHeaderView addGestureRecognizer:self.tapMapViewGesture];
                         // Center the user 's location
                         [self zoomToUserLocation: mapView.myLocation
                                      minLatitude:self.latitudeUserUp
                                         animated:self.regionAnimated];
                         
                         // Inform the delegate
                         if([self.delegate respondsToSelector:@selector(didTableViewMoveUp)]){
                             [self.delegate didTableViewMoveUp];
                         }
                     }];
}

#pragma mark - Table view Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset        = scrollView.contentOffset.y;
    CGRect headerMapViewFrame   = mapView.frame;
    
    if (scrollOffset < 0) {
        // Adjust map
        headerMapViewFrame.origin.y = self.headerYOffSet - ((scrollOffset / 2));
    } else {
        // Scrolling Up -> normal behavior
        headerMapViewFrame.origin.y = self.headerYOffSet - scrollOffset;
    }
    mapView.frame = headerMapViewFrame;
    
    // check if the Y offset is under the minus Y to reach
    if (self.tableView.contentOffset.y < self.minYOffsetToReach){
        if(!self.displayMap)
            self.displayMap                      = YES;
    }else{
        if(self.displayMap)
            self.displayMap                      = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(self.displayMap)
        [self openShutter];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *identifier;
    if(indexPath.row == 0){
        identifier = @"firstCell";
        // Add some shadow to the first cell
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
            
            CGRect cellBounds       = cell.layer.bounds;
            CGRect shadowFrame      = CGRectMake(cellBounds.origin.x, cellBounds.origin.y, tableView.frame.size.width, 10.0);
            CGPathRef shadowPath    = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
            cell.layer.shadowPath   = shadowPath;
            [cell.layer setShadowOffset:CGSizeMake(-2, -2)];
            [cell.layer setShadowColor:[[UIColor grayColor] CGColor]];
            [cell.layer setShadowOpacity:.75];
        }
    }
    else{
        identifier = @"otherCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
    }
    [[cell textLabel] setText:((MapPlace*)[self.places objectAtIndex:indexPath.row]).Title];
    [[cell textLabel] setTextAlignment:NSTextAlignmentRight];
    [[cell textLabel] setFont:[UIFont fontWithName:@"B Yekan+" size:17]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //first get total rows in that section by current indexPath.
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    
    //this is the last row in section.
    if(indexPath.row == totalRow -1){
        // get total of cells's Height
        float cellsHeight = totalRow * cell.frame.size.height;
        // calculate tableView's Height with it's the header
        float tableHeight = (tableView.frame.size.height - tableView.tableHeaderView.frame.size.height);
        
        // Check if we need to create a foot to hide the backView (the map)
        if((cellsHeight - tableView.frame.origin.y)  < tableHeight){
            // Add a footer to hide the background
            int footerHeight = tableHeight - cellsHeight;
            tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, footerHeight)];
            [tableView.tableFooterView setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MapPlace *mapPlace = ((MapPlace*)self.places[indexPath.row]);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[mapPlace.Lat doubleValue]
                                                            longitude:[mapPlace.Lng doubleValue]
                                                                 zoom:16.0];
    [mapView animateToCameraPosition:camera];
    

    
    CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[mapPlace.Lat doubleValue] longitude:[mapPlace.Lng doubleValue]];
    self.myLocation = LocationAtual;
    
    [self openShutter];
    
}


#pragma mark - MapView Delegate

- (void)zoomToUserLocation:(CLLocation *)userLocation minLatitude:(float)minLatitude animated:(BOOL)anim
{
    if (!self.myLocation)
        return;
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.myLocation.coordinate.latitude
                                                            longitude:self.myLocation.coordinate.longitude
                                                                 zoom:16.0];
    [mapView animateToCameraPosition:camera];
    
    [self performSelector:@selector(ScrollUpMap:) withObject:[NSNumber numberWithFloat:minLatitude] afterDelay:.25];
    

}

-(void)ScrollUpMap:(NSNumber*)minLatitude
{
    if ([minLatitude integerValue] != 0) {
        
        GMSCameraUpdate *downwards = [GMSCameraUpdate  scrollByX:0 Y:[minLatitude floatValue]];
        [mapView animateWithCameraUpdate:downwards];
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

//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    if(_isShutterOpen)
//        [self zoomToUserLocation:mapView.userLocation
//                     minLatitude:self.latitudeUserDown
//                        animated:self.userLocationUpdateAnimated];
//    else
//        [self zoomToUserLocation:mapView.userLocation
//                     minLatitude:self.latitudeUserUp
//                        animated:self.userLocationUpdateAnimated];
//}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapTableViewGesture) {
        return _isShutterOpen;
    }
    return YES;
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
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
