//
//  NewsTableViewController.h
//  Khodro service shahr
//
//  Created by aDb on 2/2/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicsLikeControl.h"
@interface NewsTableViewController : UITableViewController<PicsLikeControlDelegate>
@property (nonatomic, strong) NSString *newsID;
@end
