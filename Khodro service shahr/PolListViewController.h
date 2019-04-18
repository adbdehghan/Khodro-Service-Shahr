//
//  CompetitionPlusViewController.h
//  2x2
//
//  Created by aDb on 2/24/15.
//  Copyright (c) 2015 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolListViewController : UITableViewController
@property (strong, nonatomic)  NSMutableArray *competitionPlusList;
@property (nonatomic, strong) NSString *competitionID;
@property (nonatomic, strong) NSString *competitionTitle;
@end
