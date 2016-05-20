//
//  ByCategoryTableViewController.h
//  Khodro service shahr
//
//  Created by adb on 5/11/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPlace.h"

@interface ByCategoryTableViewController : UITableViewController
{
    NSMutableIndexSet *expandedSections;
}
@property (nonatomic, strong) NSString *searchedString;
@property (nonatomic, strong) MapPlace *markerLocation;
@end
