//
//  NewsViewController.h
//  Khodro service shahr
//
//  Created by aDb on 2/11/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHGallery.h"
#import "NJKScrollFullScreen.h"
#import "PicsLikeControl.h"

@interface NewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate,MHGalleryDataSource,MHGalleryDelegate,PicsLikeControlDelegate,NJKScrollFullscreenDelegate>
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@end
