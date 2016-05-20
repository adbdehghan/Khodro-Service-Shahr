//
//  ByDistanceTableViewController.h
//  Khodro service shahr
//
//  Created by adb on 5/11/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPlace.h"

@interface ByDistanceTableViewController : UITableViewController
@property (nonatomic, strong) NSString *searchedString;
@property (nonatomic)CLLocation *myLocation;
@property (nonatomic, strong) MapPlace *markerLocation;
@end
