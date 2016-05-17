//
//  HomeTableViewController.h
//  Khodro service shahr
//
//  Created by aDb on 12/26/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicsLikeControl.h"
#import "NJKScrollFullScreen.h"
#import "MHGallery.h"

@interface HomeTableViewController : UIViewController<PicsLikeControlDelegate,NJKScrollFullscreenDelegate,UIViewControllerTransitioningDelegate,MHGalleryDataSource,MHGalleryDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSString *newsID;
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@end
