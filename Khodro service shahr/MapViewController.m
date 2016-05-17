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
#import "LGFilterView.h"
#import "MapCategory.h"
#import "JTProgressHUD.h"
#import "INSSearchBar.h"
#import "AppDelegate.h"
#import "NYAlertViewController.h"
#import "SearchViewController.h"

#define SCREEN_HEIGHT_WITHOUT_STATUS_BAR     [[UIScreen mainScreen] bounds].size.height - 60
#define SCREEN_WIDTH                         [[UIScreen mainScreen] bounds].size.width
#define HEIGHT_STATUS_BAR                    60
#define Y_DOWN_TABLEVIEW                     SCREEN_HEIGHT_WITHOUT_STATUS_BAR - 60
#define DEFAULT_HEIGHT_HEADER                240.0f
#define MIN_HEIGHT_HEADER                    10.0f
#define DEFAULT_Y_OFFSET                     ([[UIScreen mainScreen] bounds].size.height == 480.0f) ? -200.0f : -250.0f
#define FULL_Y_OFFSET                        -200.0f
#define MIN_Y_OFFSET_TO_REACH                -30
#define OPEN_SHUTTER_LATITUDE_MINUS          0
#define CLOSE_SHUTTER_LATITUDE_MINUS         180

@import GoogleMaps;
static const CGFloat CalloutYOffset = 50.0f;
@interface MapViewController () <CLLocationManagerDelegate,UIGestureRecognizerDelegate,GMSMapViewDelegate,INSSearchBarDelegate,GMSAutocompleteViewControllerDelegate>

@property (strong, nonatomic)   UITapGestureRecognizer  *tapMapViewGesture;
@property (strong, nonatomic)   UITapGestureRecognizer  *tapTableViewGesture;
@property (nonatomic)           CGRect                  headerFrame;
@property (nonatomic)           float                   headerYOffSet;
@property (nonatomic)           BOOL                    isShutterOpen;
@property (nonatomic)           BOOL                    isAuthorised;
@property (nonatomic)           BOOL                    displayMap;
@property (nonatomic)           float                   heightMap;
@property (nonatomic)           CLLocation              *myLocation;
@property (nonatomic)           CLLocation              *deviceLocation;
@property (nonatomic)           CLLocation              *myCarLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) DataDownloader *getData;

@property (nonatomic, strong) NSMutableArray *placesCopy;
@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;
@property (nonatomic) NSInteger *selectedCatIndex;
@property (strong, nonatomic) LGFilterView  *categoryView;
@property (nonatomic, strong) NSMutableArray *tableItems;
@property (nonatomic, strong) NSMutableArray *categoryNameItems;
@property (nonatomic, strong) INSSearchBar *searchBarWithDelegate;
@property (nonatomic,strong)User *user;
@property (nonatomic,strong)NSString *searchedString;


@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) CLLocation *searchLocation;

@property (nonatomic, strong) NSMutableArray *results;

@end
static NSString *const ServerURL = @"http://khodroservice.kara.systems";
@implementation MapViewController
{
      GMSMapView *mapView;
    NSMutableArray *_coordinates;
    BOOL isRunning;
    LRouteController *_routeController;
    GMSPolyline *_polyline;
    GMSMarker *_markerStart;
    GMSMarker *_markerFinish;
    GMSMarker *myCarmarker;
    UIBarButtonItem *rightButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.user = app.user;
    
    self.selectedCatIndex = 0;
    [self setup];
    [self setupTableView];
    [self setupMapView];
    [self CreateMenuButton];
    
    
    self.searchBarWithDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake(10, 72, CGRectGetWidth(self.view.bounds) - 20.0, 38.0)];
    self.searchBarWithDelegate.delegate = self;
      [self.view addSubview:self.searchBarWithDelegate];
    [self.searchBarWithDelegate showSearchBar:nil];
    
    
    [self.tableView setHidden:YES];

    
    
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
    
    self.tableItems = [[NSMutableArray alloc]init];
    self.categoryNameItems = [[NSMutableArray alloc]init];
    self.places = [[NSMutableArray alloc]init];
    NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,self.categoryURL];
    
    UIImageView *markerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];

    
    [JTProgressHUD show];
    
    RequestCompleteBlock callback2 = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                MapCategory *category = [MapCategory modelFromJSONDictionary:item];
                [self.tableItems addObject:category];
                [self.categoryNameItems addObject:category.Name];
                
                
                
                
                rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Filter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterAction:)];
                self.navigationItem.rightBarButtonItem = rightButton;
                
                NSMutableArray *serial = [self loadSerial];
                
                if (serial.count > 0) {
                    
                    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                    UIImage *settingImage = [[UIImage imageNamed:@"mycar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    [menuButton setImage:settingImage forState:UIControlStateNormal];
                    
                    menuButton.tintColor = [UIColor whiteColor];
                    [menuButton addTarget:self action:@selector(ShowMyCar)forControlEvents:UIControlEventTouchUpInside];
                    [menuButton setFrame:CGRectMake(0, 0, 32, 32)];

                    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];

                    self.navigationItem.rightBarButtonItems = @[rightButton,settingBarButton];
                }
                
                
                [JTProgressHUD hide];
            }
            
        
            
            [self setupFilterViewsWithTransitionStyle:(LGFilterViewTransitionStyle)0];
        }
        
        else
        {
            [JTProgressHUD hide];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    
    [self.getData GetMapCategories:callback2];
    
    


    

    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"نقشه";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView=label;
    

    

}

-(void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *serial = [self loadSerial];
    
    if (serial.count > 0) {
        
        UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *settingImage = [[UIImage imageNamed:@"mycar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [menuButton setImage:settingImage forState:UIControlStateNormal];
        
        menuButton.tintColor = [UIColor whiteColor];
        [menuButton addTarget:self action:@selector(ShowMyCar)forControlEvents:UIControlEventTouchUpInside];
        [menuButton setFrame:CGRectMake(0, 0, 32, 32)];
        
        
        UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        
        
        self.navigationItem.rightBarButtonItems = @[rightButton,settingBarButton];
        
        
        
    }
}

-(void)ShowMyCar
{
    if (!isRunning) {
        

    [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];

 
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(GetCarLocation)
                                   userInfo:nil
                                    repeats:YES];
        isRunning = YES;
    }

}


-(void)GetCarLocation
{
    RequestCompleteBlock callback2 = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {

            
            NSDictionary *mycar = (NSDictionary*)data;
            
            if ([mycar objectForKey:@"Lat"] != nil) {
                
                self.myCarLocation =[[CLLocation alloc] initWithLatitude:[[mycar objectForKey:@"Lat"] doubleValue] longitude:[[mycar objectForKey:@"Lng"] doubleValue]];
                if (myCarmarker == nil) {
                    
                    myCarmarker = [[GMSMarker alloc] init];
                    
                    myCarmarker.position = self.myCarLocation.coordinate;
                    myCarmarker.title = @"خودرو من";
                    myCarmarker.snippet = @"";
                    myCarmarker.appearAnimation = kGMSMarkerAnimationPop;
                    myCarmarker.icon =[UIImage imageNamed:@"annotationPin"]; //markerImage.image;
                    myCarmarker.map = mapView;
                    
                    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.myCarLocation.coordinate.latitude
                                                                            longitude:self.myCarLocation.coordinate.longitude
                                                                                 zoom:18.0];
                    [mapView animateToCameraPosition:camera];
                    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                }
                else
                {
                    [CATransaction begin];
                    [CATransaction setAnimationDuration:2.0];
                    myCarmarker.position = self.myCarLocation.coordinate;
                    [CATransaction commit];
                }
            }
        }
        
        else
        {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    
    [self.getData GetGpsData:self.user.mobile password:self.user.password withCallback:callback2];

}

-(NSMutableArray*)loadSerial
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"serial.plist"];
    
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    return array;
}

- (void)showCustomUIAlertView {
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(@"یافت نشد", nil);
    alertViewController.message = NSLocalizedString(@"آیا مایلید گوگل مپ اجرا شود؟", nil);
    
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"B Yekan+" size:18];
    alertViewController.messageFont = [UIFont fontWithName:@"B Yekan+" size:16];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"B Yekan+" size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"B Yekan+" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.alertViewBackgroundColor =[UIColor colorWithWhite:0.19f alpha:1.0f];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:242/255.f green:172/255.f blue:63/255.f alpha:1.f];//[UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    
    alertViewController.buttonColor =[UIColor colorWithRed:240/255.f green:166/255.f blue:50/255.f alpha:1.f]; //[UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.buttonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    alertViewController.cancelButtonColor = [UIColor colorWithRed:240/255.f green:166/255.f blue:50/255.f alpha:1.f];//[UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.cancelButtonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"بله", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                            
                                                              [self dismissViewControllerAnimated:YES completion:nil];
//                                                              
//                                                              if ([[UIApplication sharedApplication] canOpenURL:
//                                                                   [NSURL URLWithString:@"comgooglemaps://"]]) {
//                                                                  [[UIApplication sharedApplication] openURL:
//                                                                   [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?q=%@",self.searchedString]]];
//                                                              } else {
                                                              NSString *string =[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",self.searchedString];
                                                              NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
                                                                  if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                      [[UIApplication sharedApplication] openURL:url];
                                                                  }
//                                                              }
                                                              
                                                          }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"خیر", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              
                                                              
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                  
                                                              
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}


- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    if (searchBar.searchField.text.length > 0) {
        
        [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
        
        self.places = [[NSMutableArray alloc]init];
        
        RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
            if (wasSuccessful) {
                
                [mapView clear];
                for (NSDictionary *item in (NSMutableArray*)data) {
                    
                    MapPlace *place = [MapPlace modelFromJSONDictionary:item];
                    [self.places addObject:place];
            
                    
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    
                    marker.position = CLLocationCoordinate2DMake([place.Lat doubleValue],[place.Lng doubleValue]);
                    marker.title = place.Title;
                    marker.snippet = @"";
                    marker.appearAnimation = kGMSMarkerAnimationPop;
//                    marker.icon =[UIImage imageNamed:@"marker.png"]; //markerImage.image;
                    
  
                    
                    marker.icon = [self image:[UIImage imageNamed:@"marker.png"] scaledToSize:CGSizeMake(32, 38)];
                    marker.map = mapView;
                    
                }
                [self.tableView setHidden:NO];
                
                self.placesCopy = [self.places mutableCopy];
                
                if (self.isAuthorised) {
                    [self.locationManager startUpdatingLocation];
                }
                else
                {
                    self.places = self.placesCopy;
                    [self.tableView reloadData];
                }
                
                
                if (self.places.count > 0) {
                    
                    [self performSegueWithIdentifier:@"search" sender:self];
                    
                    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                    
                    
                }
                else
                {
                      [self.tableView setHidden:YES];
//                    self.actualRequest2 = [[FTGooglePlacesAPITextSearchRequest alloc] initWithQuery:searchBar.searchField.text];
//                    [self startSearching];
                    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                    
//                    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
//                    acController.delegate = self;
//                    [self presentViewController:acController animated:YES completion:nil];
                    [self showCustomUIAlertView];
                    
                    self.searchedString = searchBar.searchField.text;
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
//                                                                    message:@"مکان مورد نظر یافت نشد"
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"تایید"
//                                                          otherButtonTitles:nil];
//                    [alert show];
                }
                
                
                
                
            }
            
            else
            {
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                                message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                               delegate:self
                                                      cancelButtonTitle:@"تایید"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
                NSLog( @"Unable to fetch Data. Try again.");
            }
        };
        
        
        [self.getData SearchLocations:searchBar.searchField.text  withCallback:callback];

    }
    
    [self.view endEditing:YES];
    [searchBar.searchField endEditing:YES];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    GMSMarker *marker = [[GMSMarker alloc] init];
    
    marker.position = place.coordinate;
    marker.title = place.name;
    marker.snippet = @"";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon =[UIImage imageNamed:@"marker.png"]; //markerImage.image;
    marker.map = mapView;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat topInset = self.navigationController.navigationBar.frame.size.height+([UIApplication sharedApplication].isStatusBarHidden ? 0.f : [UIApplication sharedApplication].statusBarFrame.size.height);
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) topInset = 0.f;

    [self updateFilterProperties:nil];
}

- (void)updateFilterProperties:(UISegmentedControl *)segmentControl
{
    
    CGFloat topInset = self.navigationController.navigationBar.frame.size.height+([UIApplication sharedApplication].isStatusBarHidden ? 0.f : [UIApplication sharedApplication].statusBarFrame.size.height);
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) topInset = 0.f;
    
    if (_categoryView.transitionStyle == LGFilterViewTransitionStyleCenter)
    {
        _categoryView.offset = CGPointMake(0.f, topInset/2);
        _categoryView.contentInset = UIEdgeInsetsZero;
    }
    else if (_categoryView.transitionStyle == LGFilterViewTransitionStyleTop)
    {
        _categoryView.contentInset = UIEdgeInsetsMake(topInset, 0.f, 0.f, 0.f);
        _categoryView.offset = CGPointZero;
    }

}

- (void)filterAction:(UIButton *)button
{
    if (!_categoryView.isShowing)
    {
        _categoryView.selectedIndex =self.selectedCatIndex;
        
        [_categoryView showInView:self.view animated:YES completionHandler:nil];
    }
    else [_categoryView dismissAnimated:YES completionHandler:nil];
}

- (void)setupFilterViewsWithTransitionStyle:(LGFilterViewTransitionStyle)style
{
    __weak typeof(self) wself = self;
    
    _categoryView = [[LGFilterView alloc] initWithTitles:self.categoryNameItems
                                          actionHandler:^(LGFilterView *filterView, NSString *title, NSUInteger index)
                    {
                        if (wself)
                        {
                            __strong typeof(wself) self = wself;
                            
                            UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
                            label.text=title;
                            label.textColor=[UIColor whiteColor];
                            label.backgroundColor =[UIColor clearColor];
                            label.adjustsFontSizeToFitWidth=YES;
                            label.font = [UIFont fontWithName:@"B Yekan+" size:19];
                            label.textAlignment = NSTextAlignmentCenter;
                            self.navigationItem.titleView=label;
                            
                            self.places =[[NSMutableArray alloc]init];
                            self.placesCopy=[[NSMutableArray alloc]init];
                            [mapView clear];
                            [JTProgressHUD show];
                            
                            RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
                                if (wasSuccessful) {
                        
                                    [JTProgressHUD hide];
                                    
                                    for (NSDictionary *item in (NSMutableArray*)data) {
                        
                                        MapPlace *place = [MapPlace modelFromJSONDictionary:item];
                                        [self.places addObject:place];
                                    
                        
                        
                                        GMSMarker *marker = [[GMSMarker alloc] init];
                        
                                        marker.position = CLLocationCoordinate2DMake([place.Lat doubleValue],[place.Lng doubleValue]);
                                        marker.title = place.Title;
                                        marker.snippet = @"";
                                        marker.appearAnimation = kGMSMarkerAnimationPop;
                                       marker.icon = [self image:[UIImage imageNamed:@"marker.png"] scaledToSize:CGSizeMake(32, 40)];
                                        marker.map = mapView;

                                    }
                                    [self.tableView setHidden:NO];

                                    self.placesCopy = [self.places mutableCopy];
                                    
                                    if (self.isAuthorised) {
                                        self.places = self.placesCopy;
                                        [self.locationManager startUpdatingLocation];
                                    }
                                    else
                                    {
                                        self.places = self.placesCopy;
                                        [self.tableView reloadData];
                                    }
                                    
                        
                                }
                        
                                else
                                {
                                    [JTProgressHUD hide];
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                                                    message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"تایید"
                                                                          otherButtonTitles:nil];
                                    [alert show];
                                    
                                    
                                    NSLog( @"Unable to fetch Data. Try again.");
                                }
                            };
                            
                            self.selectedCatIndex = index;
                            
                            self.categoryID = ((MapCategory*)self.tableItems[index]).ID;
                            [self.getData GetCategoryLocations:self.categoryID withCallback:callback];
                        
                        }
                    }
                                          cancelHandler:nil];
    _categoryView.transitionStyle = style;
    _categoryView.numberOfLines = 0;
    

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
            [mapView clear];
            [self.tableView setHidden:YES];
            _markerStart.position = [[_coordinates objectAtIndex:0] coordinate];
          //  _markerStart.map = mapView;
            
            _markerFinish.position = [[_coordinates lastObject] coordinate];
           _markerFinish.map = mapView;
            
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

-(void)CreateMenuButton
{
    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingImage = [[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuButton setImage:settingImage forState:UIControlStateNormal];
    
    menuButton.tintColor = [UIColor whiteColor];
    [menuButton addTarget:self action:@selector(GoToMenu)forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 24, 24)];
    
    
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = settingBarButton;
    
    
}

-(void)GoToMenu
{
    
    [self performSegueWithIdentifier:@"first" sender:self];
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
        
        if (self.deviceLocation != nil) {
            [_coordinates addObject:self.deviceLocation];
            [_coordinates addObject:[[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude]];
            
            
            [self getDirection];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"موقعیت"
                                                            message:@"اجازه دسترسی به موقعیت داده نشده"
                                                           delegate:self
                                                  cancelButtonTitle:@"تنظیمات"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if (buttonIndex == 0) {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
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
    [self.view endEditing:YES];
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
    _heightMap                  = self.view.frame.size.height+200;
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

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.isAuthorised = YES;
        [self.locationManager startUpdatingLocation];
    }
    
    else if(status == kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    else if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
      
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"موقعیت"
                                                        message:@"اجازه دسترسی به موقعیت داده نشده"
                                                       delegate:self
                                              cancelButtonTitle:@"تنظیمات"
                                              otherButtonTitles:@"لغو",nil];
        [alert show];
        self.isAuthorised = NO;
    }
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
    
    MapPlace *mapPlace =(MapPlace*)[self.places objectAtIndex:indexPath.row];
    
    if (mapPlace != nil) {
        [[cell textLabel] setText:((MapPlace*)[self.places objectAtIndex:indexPath.row]).Title];
        [[cell textLabel] setTextAlignment:NSTextAlignmentRight];
        [[cell textLabel] setFont:[UIFont fontWithName:@"B Yekan+" size:17]];
    }
    else
    {   
        //  Configure cell

        [[cell textLabel] setTextAlignment:NSTextAlignmentRight];
        [[cell textLabel] setFont:[UIFont fontWithName:@"B Yekan+" size:17]];
    
    }

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SearchViewController  *destination = [segue destinationViewController];
    destination.searchedString = self.searchedString;
}


@end
