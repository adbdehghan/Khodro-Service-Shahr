//
//  ByDistanceTableViewController.h
//  Khodro service shahr
//
//  Created by adb on 5/11/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ByDistanceTableViewController : UITableViewController
@property (nonatomic, strong) NSString *searchedString;
@property (nonatomic)CLLocation *myLocation;
@end
