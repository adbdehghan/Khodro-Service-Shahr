//
//  NewsViewController.m
//  Khodro service shahr
//
//  Created by aDb on 2/11/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "NewsViewController.h"
#import "DataDownloader.h"
#import "MBJSONModel.h"
#import "News.h"
#import "AppDelegate.h"
#import "NewsMedia.h"
#import "NewsCategory.h"
#import "PCStackMenu.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "HomeTableViewCell.h"
#import "UIViewController+NJKFullScreenSupport.h"
#import "NewsTableViewCell.h"
#import "NewsDetailViewController.h"

static NSString *const ServerURL = @"http://khodroservice.kara.systems";
static NSString *const cellIdentifier = @"identifier";
static NSString *const menuCellIdentifier = @"rotationCell";

@interface NewsViewController ()
{
    UIButton *filterButton;
    UIActivityIndicatorView *activityIndicator;
}
@property(nonatomic,strong) NSMutableArray *galleryDataSource;
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, strong) NSMutableArray *tableItems;
@property (nonatomic, strong) PCStackMenu *stackMenu;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *newsCategories;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *newsLiked;
@property (nonatomic, strong) UIBarButtonItem *filterBarButton;
@property (nonatomic) NJKScrollFullScreen *scrollProxy;
@property (nonatomic, strong) News *newsTO;
@property (nonatomic,strong)User *user;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.user = app.user;
    [self CreateMenuButton];
    
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self]; // UIScrollViewDelegate and UITableViewDelegate methods proxy to ViewController
    
    self.tableView.delegate = (id)_scrollProxy; // cast for surpress incompatible warnings
    
    _scrollProxy.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 400;
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(notify) name:@"Dismiss" object:nil];
    

    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [activityIndicator startAnimating];
        self.tableView.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:250/255.f alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;

    self.titles = [[NSMutableArray alloc]init];
    self.images = [[NSMutableArray alloc]init];
    self.tableItems = [[NSMutableArray alloc]init];
    self.newsLiked = [[NSMutableArray alloc]init];
    self.newsCategories = [[NSMutableArray alloc]init];
    self.galleryDataSource = [[NSMutableArray alloc]init];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self requestData];
}

#pragma mark -
#pragma mark NJKScrollFullScreenDelegate

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveNavigationBar:deltaY animated:YES];
    [self moveToolbar:-deltaY animated:YES]; // move to revese direction
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self moveNavigationBar:deltaY animated:YES];
    [self moveToolbar:-deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    [self hideNavigationBar:YES];
    [self hideToolbar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    [self showNavigationBar:YES];
    [self showToolbar:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_scrollProxy reset];
    [self showNavigationBar:YES];
    [self showToolbar:YES];
}


-(void)requestData
{


    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                News *news = [News modelFromJSONDictionary:item];
                
                [self.tableItems addObject:news];
                
                NSShadow *shadow = [[NSShadow alloc] init];
                shadow.shadowColor = [UIColor blackColor];
                shadow.shadowBlurRadius = 0.0;
                shadow.shadowOffset = CGSizeMake(0.0, 2.0);
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                [paragraphStyle setAlignment:NSTextAlignmentRight];
                
                NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:news.Detail];
                
                [string2 setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"B Yekan+" size:15],
                                         NSParagraphStyleAttributeName:paragraphStyle,
                                         NSForegroundColorAttributeName : UIColor.whiteColor,
                                         NSShadowAttributeName : shadow}
                                 range:NSMakeRange(0, string2.length)];
                
                
                NSMutableAttributedString *title  = [[NSMutableAttributedString alloc] initWithString:news.Title];
                [title setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"B Yekan+" size:15],
                                       NSParagraphStyleAttributeName:paragraphStyle,
                                       NSForegroundColorAttributeName : UIColor.whiteColor,
                                       NSShadowAttributeName : shadow}
                               range:NSMakeRange(0, title.length)];
                
                NSMutableArray *gallery = [[NSMutableArray alloc]init];
                
                for (NewsMedia *item in news.Medias) {
                    
                    if ([item.MIMEType isEqualToString:@"image"]) {
                          NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.ThumbUrl];
                        MHGalleryItem *tailored = [MHGalleryItem.alloc initWithURL:fullURL
                                                                       galleryType:MHGalleryTypeImage];
                        tailored.attributedString = string2;
                        
                        [gallery addObject:tailored];
//                        tailored.attributedTitle = title;
                    }
                    else
                    {
                          NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.Url];
                        MHGalleryItem *tailored3 = [MHGalleryItem.alloc initWithURL:fullURL
                                                                        galleryType:MHGalleryTypeVideo];
                        tailored3.attributedString = string2;
                      //  tailored3.attributedTitle = title;
                        [gallery addObject:tailored3];
                    }

                }
             
                [self.galleryDataSource addObject:gallery];
            }
            
            [activityIndicator stopAnimating];
            [self.tableView reloadData];
            
            
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    if (self.user.itemId != nil) {
        [self.getData GetEventsByID:self.user.itemId withCallback:callback];
    }
    else
        [self.getData GetEvents:@"" withCallback:callback];
    
    
    RequestCompleteBlock callback2 = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            UIButton *filterButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *filterImage = [[UIImage imageNamed:@"category"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [filterButton setImage:filterImage forState:UIControlStateNormal];
            
            filterButton.tintColor = [UIColor whiteColor];
            [filterButton addTarget:self action:@selector(ShowStackMenu)forControlEvents:UIControlEventTouchUpInside];
            [filterButton setFrame:CGRectMake(0, 0, 24, 24)];
            
            
            self.filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
            self.navigationItem.rightBarButtonItem = self.filterBarButton;
            
            [self.titles addObject:@"همه"];
            [self.images addObject:[UIImage imageNamed:@"mNews"]];
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                NewsCategory *news = [NewsCategory modelFromJSONDictionary:item];
                
                [self.newsCategories addObject:news];
                [self.titles addObject:news.Name];
                [self.images addObject:[UIImage imageNamed:@"mNews"]];
                
                
                
            }
            
            
            
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    
    [self.getData GetEventsCats:@"" withCallback:callback2];

}

-(void)CreateMenuButton
{
    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingImage = [[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuButton setImage:settingImage forState:UIControlStateNormal];
    
    menuButton.tintColor = [UIColor whiteColor];
    [menuButton addTarget:self action:@selector(GoToMenu)forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 24, 24)];
    
    
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = settingBarButton;
    
    
}

-(void)GoToMenu
{
    [_scrollProxy reset];
    [self showNavigationBar:YES];
    [self showToolbar:YES];
    
    [self performSegueWithIdentifier:@"first" sender:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self load];
    
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
    [_scrollProxy reset];
    [self showNavigationBar:YES];
    [self showToolbar:YES];

    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(notify) name:@"Dismiss" object:nil];

}

-(void)load
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    self.user = [User alloc];
    if (array.count>0) {
        self.user.itemId =[array objectAtIndex:0];
        self.user.mobile = [array objectAtIndex:2];
        self.user.password = [array objectAtIndex:3];
        // self.user.PicThumb = [array objectAtIndex:4];
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   // [self.navigationController.shyNavigationBar scrollViewDidScroll:scrollView];
}

-(void)notify
{
    [UIView animateWithDuration:0.2 animations:^{

        self.view.alpha = 1;
        
    } completion:^(BOOL finished) {
  
    }];
  
}

-(void)ShowStackMenu
{

    [UIView animateWithDuration:0.2 animations:^{
        
         self.view.alpha = .3;
        
    } completion:^(BOOL finished) {
        
    }];
    
    self.stackMenu = [[PCStackMenu alloc] initWithTitles:self.titles
                                              withImages:self.images
                                            atStartPoint:CGPointMake(self.view.frame.size.width - 11,70 )
                                                  inView:self.view.superview
                                              itemHeight:40
                                           menuDirection:PCStackMenuDirectionCounterClockWiseDown];
    for(PCStackMenuItem *item in self.stackMenu.items)
    {
        item.stackTitleLabel.textColor = [UIColor whiteColor];
        item.stackTitleLabel.font =  [UIFont fontWithName:@"B Yekan+" size:19];
    }
    
    
    [self.stackMenu show:^(NSInteger selectedMenuIndex) {
        
        
        NSLog(@"menu index : %ld", (long)selectedMenuIndex);
        
        
        [activityIndicator startAnimating];
        self.tableItems =[[ NSMutableArray alloc]init];
        self.galleryDataSource =[[ NSMutableArray alloc]init];
        [self.tableView reloadData];

        
        if (selectedMenuIndex == 0) {
            RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
                if (wasSuccessful) {
                    
                    
                    for (NSDictionary *item in (NSMutableArray*)data) {
                        
                        News *news = [News modelFromJSONDictionary:item];
                        
                        [self.tableItems addObject:news];
                        
                        NSShadow *shadow = [[NSShadow alloc] init];
                        shadow.shadowColor = [UIColor blackColor];
                        shadow.shadowBlurRadius = 0.0;
                        shadow.shadowOffset = CGSizeMake(0.0, 2.0);
                        
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        [paragraphStyle setAlignment:NSTextAlignmentRight];
                        
                        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:news.Detail];
                        
                        [string2 setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"B Yekan+" size:15],
                                                 NSParagraphStyleAttributeName:paragraphStyle,
                                                 NSForegroundColorAttributeName : UIColor.whiteColor,
                                                 NSShadowAttributeName : shadow}
                                         range:NSMakeRange(0, string2.length)];
                        
                        
                        NSMutableAttributedString *title  = [[NSMutableAttributedString alloc] initWithString:news.Title];
                        [title setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"B Yekan+" size:15],
                                               NSParagraphStyleAttributeName:paragraphStyle,
                                               NSForegroundColorAttributeName : UIColor.whiteColor,
                                               NSShadowAttributeName : shadow}
                                       range:NSMakeRange(0, title.length)];
                        
                        NSMutableArray *gallery = [[NSMutableArray alloc]init];
                        
                        for (NewsMedia *item in news.Medias) {
                            
                            if ([item.MIMEType isEqualToString:@"image"]) {
                                NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.ThumbUrl];
                                MHGalleryItem *tailored = [MHGalleryItem.alloc initWithURL:fullURL
                                                                               galleryType:MHGalleryTypeImage];
                                tailored.attributedString = string2;
                                
                                [gallery addObject:tailored];
                                tailored.attributedTitle = title;
                            }
                            else
                            {
                                NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.Url];
                                MHGalleryItem *tailored3 = [MHGalleryItem.alloc initWithURL:fullURL
                                                                                galleryType:MHGalleryTypeVideo];
                                tailored3.attributedString = string2;
                                //  tailored3.attributedTitle = title;
                                [gallery addObject:tailored3];
                            }
                            
                        }
                        
                        [self.galleryDataSource addObject:gallery];
                    }
                    
                    [activityIndicator stopAnimating];
                    [self.tableView reloadData];
                    

                    
                    
                }
                
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                                    message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                                   delegate:self
                                                          cancelButtonTitle:@"تایید"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    
                    NSLog( @"Unable to fetch Data. Try again.");
                }
            };
            
            
            [self.getData GetEvents:@"" withCallback:callback];
            
        }
        else
        {
            RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
                if (wasSuccessful) {
                    
                    self.tableItems = [[ NSMutableArray alloc]init];
                    self.galleryDataSource = [[ NSMutableArray alloc]init];
                    
                    for (NSDictionary *item in (NSMutableArray*)data) {
                        
                        News *news = [News modelFromJSONDictionary:item];
                        
                        [self.tableItems addObject:news];
                        
                        NSShadow *shadow = [[NSShadow alloc] init];
                        shadow.shadowColor = [UIColor blackColor];
                        shadow.shadowBlurRadius = 0.0;
                        shadow.shadowOffset = CGSizeMake(0.0, 2.0);
                        
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        [paragraphStyle setAlignment:NSTextAlignmentRight];
                        
                        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:news.Detail];
                        
                        [string2 setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"B Yekan+" size:15],
                                                 NSParagraphStyleAttributeName:paragraphStyle,
                                                 NSForegroundColorAttributeName : UIColor.whiteColor,
                                                 NSShadowAttributeName : shadow}
                                         range:NSMakeRange(0, string2.length)];
                        
                        
                        NSMutableAttributedString *title  = [[NSMutableAttributedString alloc] initWithString:news.Title];
                        [title setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"B Yekan+" size:15],
                                               NSParagraphStyleAttributeName:paragraphStyle,
                                               NSForegroundColorAttributeName : UIColor.whiteColor,
                                               NSShadowAttributeName : shadow}
                                       range:NSMakeRange(0, title.length)];
                        
                        NSMutableArray *gallery = [[NSMutableArray alloc]init];
                        
                        for (NewsMedia *item in news.Medias) {
                            
                            if ([item.MIMEType isEqualToString:@"image"]) {
                                NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.ThumbUrl];
                                MHGalleryItem *tailored = [MHGalleryItem.alloc initWithURL:fullURL
                                                                               galleryType:MHGalleryTypeImage];
                                tailored.attributedString = string2;
                                
                                [gallery addObject:tailored];
                                tailored.attributedTitle = title;
                            }
                            else
                            {
                                NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.Url];
                                MHGalleryItem *tailored3 = [MHGalleryItem.alloc initWithURL:fullURL
                                                                                galleryType:MHGalleryTypeVideo];
                                tailored3.attributedString = string2;
                                //  tailored3.attributedTitle = title;
                                [gallery addObject:tailored3];
                            }
                            
                        }
                        
                        [self.galleryDataSource addObject:gallery];
                    }
                    
                    [activityIndicator stopAnimating];
                    [self.tableView reloadData];
                    
                }
                
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                                    message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                                   delegate:self
                                                          cancelButtonTitle:@"تایید"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    
                    NSLog( @"Unable to fetch Data. Try again.");
                }
            };
            
            NSString *catID = ((NewsCategory*)[self.newsCategories objectAtIndex:selectedMenuIndex-1]).ID;
            
            [self.getData GetEventByCat:catID withCallback:callback];
        }
        
    }];
    
    
    
}

- (void)controlTappedAtIndex:(int)index Sender:(id)sender
{
    if (self.user.itemId != nil) {
        
        
        NSLog(@"index at %d tapped", index);
        NSLog(@"tag: %ld tapped", (long)((PicsLikeControl*)(sender)).tag);
        
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
       
        HomeTableViewCell *cell=[self.tableView cellForRowAtIndexPath:hitIndex];
        
        News *item = [self.tableItems objectAtIndex:hitIndex.section];
        
        
        
        NSInteger likeCount = [cell.likeCountLabel.text integerValue];
        
        if (index == 0)
        {
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld",likeCount + 1];
            [self.newsLiked addObject:item.ID];
            
            
            RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
                if (wasSuccessful) {
                    
                    for (NSDictionary *item in (NSMutableArray*)data) {
                        
                    }
                    
                }
                
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                                    message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                                   delegate:self
                                                          cancelButtonTitle:@"تایید"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    
                    NSLog( @"Unable to fetch Data. Try again.");
                }
            };
            
            
            [self.getData LikeNews:self.user.mobile Password:self.user.password eventID:item.ID   withCallback:callback];
            
            
        }
        else
        {
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld",likeCount - 1];
            [self.newsLiked removeObject:item.ID];
            item.LikeCount = [NSString stringWithFormat:@"%ld",likeCount - 1];
            item.IsLiked = @"0";
        }
    }
    else
    {
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        
        HomeTableViewCell *cell=[self.tableView cellForRowAtIndexPath:hitIndex];
        
        
        [cell.likeContainerView Dislike];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                        message:@"ابتدا وارد شوید"
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if ([self.presentedViewController isKindOfClass:[MHGalleryController class]]) {
        MHGalleryController *gallerController = (MHGalleryController*)self.presentedViewController;
        return gallerController.preferredStatusBarStyleMH;
    }
    return UIStatusBarStyleDefault;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.galleryDataSource.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.galleryDataSource[collectionView.tag] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.view.frame.size.height>700) {
        return 600;
    }
    else
        return 400;

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = nil;
    cellIdentifier = @"TestCell";
    
    NewsTableViewCell *cell = (NewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell){
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    News *news = [self.tableItems objectAtIndex:indexPath.section];
    
    cell.titleLabel.text = news.Title;
    cell.descriptionLabel.text = news.Detail;
    
    if (news.Medias.count > 0) {
        

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        if (self.view.frame.size.height>700) {
            layout.itemSize = CGSizeMake(self.view.frame.size.width - 20, 430);
        }
        else
            layout.itemSize = CGSizeMake(self.view.frame.size.width - 20, 225);
        
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cell.collectionView.collectionViewLayout = layout;
    }

    [cell.collectionView registerClass:[MHMediaPreviewCollectionViewCell class] forCellWithReuseIdentifier:@"MHMediaPreviewCollectionViewCell"];
    
    cell.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    cell.collectionView.backgroundColor = [UIColor clearColor];
    [cell.collectionView setShowsHorizontalScrollIndicator:NO];
    [cell.collectionView setDelegate:self];
    [cell.collectionView setDataSource:self];
    [cell.collectionView setTag:indexPath.section];
    [cell.collectionView reloadData];
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (news.Medias.count > 0) {
        cell.ImageViewContainer.hidden = YES;
    }
    else
        cell.ImageViewContainer.hidden = NO;
    
    if (![self.newsLiked containsObject:news.ID]) {
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%@",news.LikeCount];
        
        UIImage *image0 = [UIImage imageNamed:@"nonlike"];
        UIImage *image1 = [UIImage imageNamed:@"like"];
        NSArray *images = @[image0, image1];
        
        [cell.likeContainerView SetmultiImages:images];
        cell.likeContainerView.tag = [news.ID integerValue];
        
        cell.likeContainerView.delegate = self;
    }
    else
    {
        
        NSInteger likeCount = [news.LikeCount integerValue];
        
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld",likeCount + 1];
        [cell.likeContainerView ManualTap];
        cell.likeContainerView.tag = [news.ID integerValue];
        
        cell.likeContainerView.delegate = self;

    }
    if ([[NSString stringWithFormat:@"%@",news.IsLiked] isEqualToString:@"1"]) {
        [cell.likeContainerView ManualTap];
    }
    cell.backgroundColor =[UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.newsTO = [self.tableItems objectAtIndex:indexPath.section];
    
    [_scrollProxy reset];
    [self showNavigationBar:YES];
    [self showToolbar:YES];
    
    [self performSegueWithIdentifier:@"detail" sender:self];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell =nil;
    NSString *cellIdentifier = @"MHMediaPreviewCollectionViewCell";
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:indexPath.row inSection:collectionView.tag];
    [self makeOverViewDetailCell:(MHMediaPreviewCollectionViewCell*)cell atIndexPath:indexPathNew];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    UIImageView *imageView = [(MHMediaPreviewCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath] thumbnail];
//    
//    NSArray *galleryData = self.galleryDataSource[collectionView.tag];
//    
//    MHGalleryController *gallery = [MHGalleryController galleryWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarShown];
//    gallery.galleryItems = galleryData;
//    gallery.presentingFromImageView = imageView;
//    gallery.presentationIndex = indexPath.row;
//    
//    // gallery.UICustomization.hideShare = YES;
//    gallery.galleryDelegate = self;
//    //  gallery.dataSource = self;
//    __weak MHGalleryController *blockGallery = gallery;
//    
//    gallery.finishedCallback = ^(NSInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition,MHGalleryViewMode viewMode){
//        if (viewMode == MHGalleryViewModeOverView) {
//            [blockGallery dismissViewControllerAnimated:YES completion:^{
//                [self setNeedsStatusBarAppearanceUpdate];
//            }];
//        }else{
//            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
//            CGRect cellFrame  = [[collectionView collectionViewLayout] layoutAttributesForItemAtIndexPath:newIndexPath].frame;
//            [collectionView scrollRectToVisible:cellFrame
//                                       animated:NO];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [collectionView reloadItemsAtIndexPaths:@[newIndexPath]];
//                [collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//                
//                MHMediaPreviewCollectionViewCell *cell = (MHMediaPreviewCollectionViewCell*)[collectionView cellForItemAtIndexPath:newIndexPath];
//                
//                [blockGallery dismissViewControllerAnimated:YES dismissImageView:cell.thumbnail completion:^{
//                    
//                    [self setNeedsStatusBarAppearanceUpdate];
//                    
//                    MPMoviePlayerController *player = interactiveTransition.moviePlayer;
//                
//                    player.controlStyle = MPMovieControlStyleEmbedded;
//                    player.view.frame = cell.bounds;
//                    player.scalingMode = MPMovieScalingModeAspectFill;
//                    [cell.contentView addSubview:player.view];
//                }];
//            });
//        }
//    };
//    [self presentMHGalleryController:gallery animated:YES completion:nil];
}


-(NSInteger)numberOfItemsInGallery:(MHGalleryController *)galleryController{
    return 10;
}

-(BOOL)galleryController:(MHGalleryController*)galleryController shouldHandleURL:(NSURL *)URL{
    return YES;
}

-(MHGalleryItem *)itemForIndex:(NSInteger)index{
    // You also have to set the image in the Testcell to get the correct Animation
    //    return [MHGalleryItem.alloc initWithImage:nil];
    return [MHGalleryItem itemWithImage:MHGalleryImage(@"image")];
}

-(void)makeOverViewDetailCell:(MHMediaPreviewCollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    MHGalleryItem *item = self.galleryDataSource[indexPath.section][indexPath.row];
    cell.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.thumbnail.image = nil;
    cell.galleryItem = item;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

   if([segue.identifier isEqualToString:@"detail"])
    {
        NewsDetailViewController *destination = [segue destinationViewController];
        destination.news = self.newsTO;
        
    }
    
}

@end
