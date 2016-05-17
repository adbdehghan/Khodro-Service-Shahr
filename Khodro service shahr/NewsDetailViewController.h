//
//  NewsDetailViewController.h
//  Khodro service shahr
//
//  Created by aDb on 2/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "MHGallery.h"
#import "NJKScrollFullScreen.h"
#import "NewsTableViewCell.h"
#import "PicsLikeControl.h"

@interface NewsDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate,MHGalleryDataSource,MHGalleryDelegate,PicsLikeControlDelegate>
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)News *news;
@end
