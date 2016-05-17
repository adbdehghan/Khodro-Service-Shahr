//
//  SearchViewController.h
//  Khodro service shahr
//
//  Created by adb on 5/8/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSegmentedPagerController.h"
#import <MapKit/MapKit.h>

@interface SearchViewController : MXSegmentedPagerController
@property (nonatomic)CLLocation *myLocation;
@property (nonatomic, strong) NSString *searchedString;
@end
