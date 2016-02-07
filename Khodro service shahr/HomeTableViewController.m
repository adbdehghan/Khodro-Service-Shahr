//
//  HomeTableViewController.m
//  Khodro service shahr
//
//  Created by aDb on 12/26/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeTableViewCell.h"
#import "JDFPeekabooCoordinator.h"
#import "DataDownloader.h"
#import "MBJSONModel.h"
#import "Media.h"
#import "NewsMedia.h"
#import "LCBannerView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "CommentViewController.h"
#import "AppDelegate.h"

static NSString *const cellIdentifier = @"identifier";
static NSString *const ServerURL = @"http://khodroservice.kara.systems";

@interface HomeTableViewController ()
{
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, strong) NSMutableArray *tableItems;
@property (nonatomic, strong) NSMutableArray *newsLiked;
@property (nonatomic,strong)User *user;
@end

@implementation HomeTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreateMenuButton];
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

    
  //  [self.tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    self.tableItems = [[NSMutableArray alloc]init];
    self.newsLiked = [[NSMutableArray alloc]init];
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                Media *media = [Media modelFromJSONDictionary:item];
                [self.tableItems addObject:media];
                
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
    
    
    [self.getData RequestMedia:@"" withCallback:callback];
    
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
}

- (void)controlTappedAtIndex:(int)index Sender:(id)sender
{
    
    if (self.user != nil) {
        NSLog(@"index at %d tapped", index);
        NSLog(@"tag: %ld tapped", (long)((PicsLikeControl*)(sender)).tag);
        
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        
        HomeTableViewCell *cell=[self.tableView cellForRowAtIndexPath:hitIndex];
        
        Media *item = [self.tableItems objectAtIndex:hitIndex.row];
        
        
        
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
            
            
            [self.getData LikeMedia:self.user.mobile Password:self.user.password eventID:item.ID   withCallback:callback];
            
            
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
                                                        message:@" ابتدا وارد شوید"
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 460;
}

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
    
    Media *media = [self.tableItems objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = media.Caption;
    cell.descriptionLabel.text = media.Comment;
    
    cell.commnetCountLabel.text = [NSString stringWithFormat:@"%@",media.CommentCount];
    
    cell.commnetButton.tag = indexPath.row;
    [cell.commnetButton addTarget:self action:@selector(AddComment:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor =[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray *URLs = [[NSMutableArray alloc]init];
    
    for (NewsMedia *item in media.items) {
        
        NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.ThumbUrl];
        [URLs addObject:fullURL];
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
    
    if (![self.newsLiked containsObject:media.ID]) {
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%@",media.LikeCount];
        
        UIImage *image0 = [UIImage imageNamed:@"nonlike"];
        UIImage *image1 = [UIImage imageNamed:@"like"];
        NSArray *images = @[image0, image1];
        
        [cell.likeContainerView SetmultiImages:images];
        cell.likeContainerView.tag = [media.ID integerValue];
        
        cell.likeContainerView.delegate = self;
    }
    else
    {
        
        NSInteger likeCount = [media.LikeCount integerValue];
        
        
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld",likeCount + 1];
        
        
        
        [cell.likeContainerView ManualTap];
        cell.likeContainerView.tag = [media.ID integerValue];
        
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


-(void)AddComment:(id)sender
{
    Media *media = [self.tableItems objectAtIndex:((UIButton*)sender).tag];
    self.newsID = media.ID;
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
        destination.mediaID = self.newsID;
    }

}

@end
