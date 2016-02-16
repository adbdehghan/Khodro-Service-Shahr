//
//  MapViewController.h
//  Khodro service shahr
//
//  Created by aDb on 1/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol SLParallaxControllerDelegate <NSObject>

// Tap handlers
-(void)didTapOnMapView;
-(void)didTapOnTableView;
// TableView's move
-(void)didTableViewMoveDown;
-(void)didTableViewMoveUp;

@end

@interface MapViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)     id<SLParallaxControllerDelegate>    delegate;
@property (nonatomic, strong)   UITableView                         *tableView;
@property (nonatomic)           float                               heighTableView;
@property (nonatomic)           float                               heighTableViewHeader;
@property (nonatomic)           float                               minHeighTableViewHeader;
@property (nonatomic)           float                               minYOffsetToReach;
@property (nonatomic)           float                               default_Y_mapView;
@property (nonatomic)           float                               default_Y_tableView;
@property (nonatomic)           float                               Y_tableViewOnBottom;
@property (nonatomic)           float                               latitudeUserUp;
@property (nonatomic)           float                               latitudeUserDown;
@property (nonatomic)           BOOL                                regionAnimated;
@property (nonatomic)           BOOL                                userLocationUpdateAnimated;
@property (nonatomic, strong)   NSString                         *categoryID;
@property (nonatomic, strong)   NSString                         *categoryName;
@property (nonatomic, strong)   NSString                         *categoryURL;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSMutableArray *searchplaces;
// Move the map in terms of user location
// @minLatitude : subtract to the current user's latitude to move it on Y axis in order to view it when the map move
- (void)zoomToUserLocation:(CLLocation *)userLocation minLatitude:(float)minLatitude animated:(BOOL)anim;

@end
