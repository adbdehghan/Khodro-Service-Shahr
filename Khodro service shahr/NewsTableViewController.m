//
//  NewsTableViewController.m
//  Khodro service shahr
//
//  Created by aDb on 2/2/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "NewsTableViewController.h"
#import "HomeTableViewCell.h"
#import "JDFPeekabooCoordinator.h"
#import "DataDownloader.h"
#import "MBJSONModel.h"
#import "News.h"
#import "LCBannerView.h"
#import "NewsMedia.h"
#import "NewsCategory.h"
#import "PCStackMenu.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "CommentViewController.h"
#import "NewsDetailViewController.h"
#import "AppDelegate.h"
#import "MHOverViewController.h"

static NSString *const ServerURL = @"http://khodroservice.kara.systems";
static NSString *const cellIdentifier = @"identifier";
static NSString *const menuCellIdentifier = @"rotationCell";

@interface NewsTableViewController ()<LCBannerViewDelegate>
{
    UIView *_contentView;
    UIButton *filterButton;

}
@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, strong) NSMutableArray *tableItems;

@property (nonatomic, strong) PCStackMenu *stackMenu;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *newsCategories;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *newsLiked;
@property (nonatomic, strong) UIBarButtonItem *filterBarButton;
@property (nonatomic, strong) News *newsTO;
@property (nonatomic,strong)User *user;

@end

@implementation NewsTableViewController

UIActivityIndicatorView *activityIndicator;


- (void)viewDidLoad {
    [super viewDidLoad];

    [self CreateMenuButton];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(notify) name:@"Dismiss" object:nil];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.user = app.user;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [activityIndicator startAnimating];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
    self.scrollCoordinator.scrollView = self.tableView;
    self.scrollCoordinator.topView = self.navigationController.navigationBar;
    self.scrollCoordinator.topViewMinimisedHeight = 20.0f;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:250/255.f alpha:1];
    

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

    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                News *news = [News modelFromJSONDictionary:item];
                
                [self.tableItems addObject:news];
                
            }
            
            [activityIndicator stopAnimating];
            [self.tableView reloadData];
            
            
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"خب"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    
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
                                                  cancelButtonTitle:@"خب"
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
    
    [self performSegueWithIdentifier:@"first" sender:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollCoordinator enable];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(notify) name:@"Dismiss" object:nil];
}

-(void)notify
{
    self.view.alpha = 1;
}

-(void)ShowStackMenu
{
    self.view.alpha = .3;
    self.stackMenu = [[PCStackMenu alloc] initWithTitles:self.titles
                                              withImages:self.images
                                            atStartPoint:CGPointMake(self.view.frame.size.width - 11,70 )
                                                  inView:self.view
                                              itemHeight:40
                                           menuDirection:PCStackMenuDirectionCounterClockWiseDown];
    for(PCStackMenuItem *item in self.stackMenu.items)
    {
        item.stackTitleLabel.textColor = [UIColor colorWithRed:100/255.f green:184/255.f blue:34/255.f alpha:1];
        item.stackTitleLabel.font =  [UIFont fontWithName:@"B Yekan+" size:19];
    }
    
    
    [self.stackMenu show:^(NSInteger selectedMenuIndex) {
        
        
        NSLog(@"menu index : %ld", (long)selectedMenuIndex);
        
        
        [activityIndicator startAnimating];
         [self.tableItems removeAllObjects];
        [self.tableView reloadData];
        
        if (selectedMenuIndex == 0) {
            RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
                if (wasSuccessful) {
                    
                    
                    for (NSDictionary *item in (NSMutableArray*)data) {
                        
                        News *news = [News modelFromJSONDictionary:item];
                        [self.tableItems addObject:news];
                        
                    }
                    
                    [activityIndicator stopAnimating];
                    [self.tableView reloadData];
                    
                    
                }
                
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                                    message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                                   delegate:self
                                                          cancelButtonTitle:@"خب"
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
                
                [self.tableItems removeAllObjects];
                
                for (NSDictionary *item in (NSMutableArray*)data) {
                    
                    News *news = [News modelFromJSONDictionary:item];
                    [self.tableItems addObject:news];

                    
                }
                
                [activityIndicator stopAnimating];
                [self.tableView reloadData];
                
            }
            
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                                message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                               delegate:self
                                                      cancelButtonTitle:@"خب"
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
    if (self.user != nil) {
        
        
        NSLog(@"index at %d tapped", index);
        NSLog(@"tag: %ld tapped", (long)((PicsLikeControl*)(sender)).tag);
        
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        
        HomeTableViewCell *cell=[self.tableView cellForRowAtIndexPath:hitIndex];
        
        News *item = [self.tableItems objectAtIndex:hitIndex.row];
        
        
        
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
                                                          cancelButtonTitle:@"خب"
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
        }
    }
    else
    {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                        message:@"ابتدا وارد شوید"
                                                       delegate:self
                                              cancelButtonTitle:@"خب"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 460;
//}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil) {
            cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        
        News *news = [self.tableItems objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = news.Title;
        cell.descriptionLabel.text = news.Detail;

//        cell.commnetCountLabel.text = [NSString stringWithFormat:@"%@",news.CommentCount];
    
    cell.commnetButton.tag = indexPath.row;
    [cell.commnetButton addTarget:self action:@selector(AddComment:) forControlEvents:UIControlEventTouchUpInside];
    
        cell.backgroundColor =[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableArray *URLs = [[NSMutableArray alloc]init];
        
        for (NewsMedia *item in news.Medias) {
            
            NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.ThumbUrl];
            [URLs addObject:fullURL];
            
            if ([item.MIMEType isEqualToString:@"image"]) {
                MHGalleryItem *image1 = [MHGalleryItem itemWithURL:fullURL galleryType:MHGalleryTypeImage];
            }
            else
            {
                MHGalleryItem *video = [[MHGalleryItem alloc]initWithURL:fullURL
                                                           galleryType:MHGalleryTypeVideo];
            }
        }
        
        int time = 4;
        
        if (URLs.count == 1)
            time = 0;

    
    if (URLs.count > 1) {
        
       // for (NSString *url in URLs) {
            
         //   UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.ImageViewContainer.frame];
            
            [cell.ImageViewContainer setImageWithURL:[NSURL URLWithString:URLs[0]]
                                    placeholderImage:[UIImage imageNamed:@"image"] options:SDWebImageRefreshCached usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)UIActivityIndicatorViewStyleGray];
            
//            LCBannerView *bannerView = [[LCBannerView alloc] initWithFrame:CGRectMake(0, 0, cell.ImageContainer.frame.size.width, cell.ImageContainer.frame.size.height)
//                                                                  delegate:self
//                                                                 imageName:imageView.image
//                                                                     count:URLs.count
//                                                             timerInterval:4.0f
//                                             currentPageIndicatorTintColor:[UIColor greenColor]
//                                                    pageIndicatorTintColor:[UIColor whiteColor]];
//
//        [cell.ImageContainer addSubview:bannerView];
        //}
    }
    else if(URLs.count == 1)
    {
        [cell.ImageViewContainer setImageWithURL:URLs[0]
                         placeholderImage:[UIImage imageNamed:@"image"] options:SDWebImageRefreshCached usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)UIActivityIndicatorViewStyleGray];
    }
    else
    {

        [cell.ImageViewContainer setImage:[UIImage imageNamed:@"image"]];
        [cell.ImageContainer setBackgroundColor:[UIColor clearColor]];
    }
    
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
    
//        if ([[cell.likeContainerView subviews] count]==0) {
//            UIImage *image0 = [UIImage imageNamed:@"nonlike"];
//            UIImage *image1 = [UIImage imageNamed:@"like"];
//            NSArray *images = @[image0, image1];
//            
//            PicsLikeControl *picControl = [[PicsLikeControl alloc] initWithFrame:CGRectMake(5, 0, 30, 30) multiImages:images];
//            picControl.tag = [news.ID integerValue];
//            
//            picControl.delegate = self;
//            
//            [cell.likeContainerView addSubview:picControl];
//        }

        
        return cell;

   }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.newsTO = [self.tableItems objectAtIndex:indexPath.row];
     [self.scrollCoordinator disable];
    [self performSegueWithIdentifier:@"detail" sender:self];
}

-(void)AddComment:(id)sender
{
    News *news = [self.tableItems objectAtIndex:((UIButton*)sender).tag];
    self.newsID = news.ID;
    [self.scrollCoordinator fullyExpandViews];
    [self.scrollCoordinator disable];
    [self performSegueWithIdentifier:@"addcomment" sender:self];
}


- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addcomment"]) {
        CommentViewController *destination = [segue destinationViewController];
        destination.newsID = self.newsID;
    }
    else if([segue.identifier isEqualToString:@"detail"])
    {
        NewsDetailViewController *destination = [segue destinationViewController];
        destination.news = self.newsTO;
    
    }
    
}

@end
