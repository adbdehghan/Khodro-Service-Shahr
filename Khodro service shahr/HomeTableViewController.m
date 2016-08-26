//
//  HomeTableViewController.m
//  Khodro service shahr
//
//  Created by aDb on 12/26/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeTableViewCell.h"
#import "DataDownloader.h"
#import "MBJSONModel.h"
#import "Media.h"
#import "NewsMedia.h"
#import "LCBannerView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "CommentViewController.h"
#import "AppDelegate.h"
#import "UIViewController+NJKFullScreenSupport.h"
#import "MediaCollectionViewCell.h"


static NSString *const cellIdentifier = @"TestCell";
static NSString *const ServerURL = @"http://khodroservice.kara.systems";

@interface HomeTableViewController ()
{
    UIActivityIndicatorView *activityIndicator;
}
@property(nonatomic,strong) NSMutableArray *galleryDataSource;
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, strong) NSMutableArray *tableItems;
@property (nonatomic, strong) NSMutableArray *newsLiked;
@property (nonatomic,strong)User *user;
@property (nonatomic) NJKScrollFullScreen *scrollProxy;
@end

@implementation HomeTableViewController

-(void)makeOverViewDetailCell:(MHMediaPreviewCollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
  
        MHGalleryItem *item = self.galleryDataSource[indexPath.section][indexPath.row];
        cell.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.thumbnail.image = nil;
        cell.galleryItem = item;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreateMenuButton];
    
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self]; // UIScrollViewDelegate and UITableViewDelegate methods proxy to ViewController
    
    self.tableView.delegate = (id)_scrollProxy; // cast for surpress incompatible warnings
    
    _scrollProxy.delegate = self;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.user = app.user;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [activityIndicator startAnimating];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
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
    
    self.tableItems = [[NSMutableArray alloc]init];
    self.newsLiked = [[NSMutableArray alloc]init];
    self.galleryDataSource = [[NSMutableArray alloc]init];

    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                Media *media = [Media modelFromJSONDictionary:item];
                [self.tableItems addObject:media];
                
                NSShadow *shadow = [[NSShadow alloc] init];
                shadow.shadowColor = [UIColor blackColor];
                shadow.shadowBlurRadius = 0.0;
                shadow.shadowOffset = CGSizeMake(0.0, 2.0);
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                [paragraphStyle setAlignment:NSTextAlignmentRight];
                
                NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:media.Caption == nil ? @"" : media.Caption];
                
                [string2 setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"B Yekan+" size:15],
                                         NSParagraphStyleAttributeName:paragraphStyle,
                                         NSForegroundColorAttributeName : UIColor.whiteColor,
                                         NSShadowAttributeName : shadow}
                                 range:NSMakeRange(0, string2.length)];
                
                
                NSMutableAttributedString *title  = [[NSMutableAttributedString alloc] initWithString:media.Comment==nil ? @"" :media.Comment];
                [title setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"B Yekan+" size:15],
                                       NSParagraphStyleAttributeName:paragraphStyle,
                                       NSForegroundColorAttributeName : UIColor.whiteColor,
                                       NSShadowAttributeName : shadow}
                               range:NSMakeRange(0, title.length)];
                
                NSMutableArray *gallery = [[NSMutableArray alloc]init];
                
                
                for (NewsMedia *item in media.items) {
                    
                    if ([item.MIMEType isEqualToString:@"image"]) {
                        NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.ThumbUrl];
                        MHGalleryItem *tailored = [MHGalleryItem.alloc initWithURL:fullURL
                                                                       galleryType:MHGalleryTypeImage];
                        tailored.attributedString = string2;
                        
                        [gallery addObject:tailored];
                        //                        tailored.attributedTitle = title;
                    }
                    else if([item.MIMEType isEqualToString:@"video"])
                    {
                        NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.Url];
                        MHGalleryItem *tailored3 = [MHGalleryItem.alloc initWithURL:fullURL
                                                                        galleryType:MHGalleryTypeVideo];
                        tailored3.attributedString = string2;
                        //  tailored3.attributedTitle = title;
                        [gallery addObject:tailored3];
                    }
                    
                    else{
//                        NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.Url];
//                        
//                        LMMediaItem *item1 = [[LMMediaItem alloc] initWithInfo:@{
//                                                                                 LMMediaItemInfoURLKey:[NSURL URLWithString:fullURL],
//                                                                                 LMMediaItemInfoContentTypeKey:@(LMMediaItemContentTypeAudio)
//                                                                                 }];
//                        
//                        [gallery addObject:item1];
                        
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
        [self.getData RequestMediaByProfileID:self.user.itemId withCallback:callback];
    }
    else
        [self.getData RequestMedia:@"" withCallback:callback];
    
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
    [self load];
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

- (void)controlTappedAtIndex:(int)index Sender:(id)sender
{
    
    if (self.user.itemId != nil) {
        NSLog(@"index at %d tapped", index);
        NSLog(@"tag: %ld tapped", (long)((PicsLikeControl*)(sender)).tag);
        
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        
        HomeTableViewCell *cell=[self.tableView cellForRowAtIndexPath:hitIndex];
        
        Media *item = [self.tableItems objectAtIndex:hitIndex.section];
        
        
        
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
            
            
            [self.getData LikeMedia:self.user.mobile Password:self.user.password eventID:item.ID   withCallback:callback];
            
            
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
                                                        message:@" ابتدا وارد شوید"
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    Media *media = [self.tableItems objectAtIndex:indexPath.section];
    
    cell.titleLabel.text = media.Caption;
    cell.descriptionLabel.text = media.Comment;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (media.items.count > 0) {
        
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
    
//    [cell.collectionView registerClass:[MediaCollectionViewCell class] forCellWithReuseIdentifier:@"MHMediaPreviewCollectionViewCell"];
    [cell.collectionView registerClass:[MHMediaPreviewCollectionViewCell class] forCellWithReuseIdentifier:@"MHMediaPreviewCollectionViewCell"];
    cell.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    cell.collectionView.backgroundColor = [UIColor clearColor];
    [cell.collectionView setShowsHorizontalScrollIndicator:NO];
    [cell.collectionView setDelegate:self];
    [cell.collectionView setDataSource:self];
    [cell.collectionView setTag:indexPath.section];
    [cell.collectionView reloadData];
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (media.items.count > 0) {
        cell.ImageViewContainer.hidden = YES;
    }
    else
        cell.ImageViewContainer.hidden = NO;
    
    if (![self.newsLiked containsObject:media.ID]) {
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%@",media.LikeCount];
        
        UIImage *image0 = [UIImage imageNamed:@"nonlike.png"];
        UIImage *image1 = [UIImage imageNamed:@"like.png"];
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
    if ([[NSString stringWithFormat:@"%@",media.IsLiked] isEqualToString:@"1"]) {
        [cell.likeContainerView ManualTap];
    }
    
    cell.backgroundColor =[UIColor clearColor];
    
    return cell;
}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell =nil;
//    NSString *cellIdentifier = @"MHMediaPreviewCollectionViewCell";
//    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:indexPath.row inSection:collectionView.tag];
//    
//
//    [self makeOverViewDetailCell:(MediaCollectionViewCell*)cell atIndexPath:indexPathNew];
//    
//    return cell;
//}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell =nil;
    NSString *cellIdentifier = @"MHMediaPreviewCollectionViewCell";
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:indexPath.row inSection:collectionView.tag];
    [self makeOverViewDetailCell:(MHMediaPreviewCollectionViewCell*)cell atIndexPath:indexPathNew];
    
    return cell;
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
        UIImageView *imageView = [(MHMediaPreviewCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath] thumbnail];
    
        NSArray *galleryData = self.galleryDataSource[collectionView.tag];
    
        MHGalleryController *gallery = [MHGalleryController galleryWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarShown];
        gallery.galleryItems = galleryData;
        gallery.presentingFromImageView = imageView;
    gallery.presentationIndex = indexPath.row;
    gallery.presentationStyle = MHGalleryViewModeOverView;
        // gallery.UICustomization.hideShare = YES
    gallery.transitionCustomization.interactiveDismiss = NO;
        gallery.galleryDelegate = self;
        //  gallery.dataSource = self;
        __weak MHGalleryController *blockGallery = gallery;
    
        gallery.finishedCallback = ^(NSInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition,MHGalleryViewMode viewMode){
            if (viewMode == MHGalleryViewModeOverView) {
                [blockGallery dismissViewControllerAnimated:YES completion:^{
                    [self setNeedsStatusBarAppearanceUpdate];
                }];
            }else{
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
                CGRect cellFrame  = [[collectionView collectionViewLayout] layoutAttributesForItemAtIndexPath:newIndexPath].frame;
                [collectionView scrollRectToVisible:cellFrame
                                           animated:NO];
    
                dispatch_async(dispatch_get_main_queue(), ^{
                    [collectionView reloadItemsAtIndexPaths:@[newIndexPath]];
                    [collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
                    MHMediaPreviewCollectionViewCell *cell = (MHMediaPreviewCollectionViewCell*)[collectionView cellForItemAtIndexPath:newIndexPath];
    
                    [blockGallery dismissViewControllerAnimated:YES dismissImageView:cell.thumbnail completion:^{
    
                        [self setNeedsStatusBarAppearanceUpdate];
    
                        MPMoviePlayerController *player = interactiveTransition.moviePlayer;
    
                        player.controlStyle = MPMovieControlStyleEmbedded;
                        player.view.frame = cell.bounds;
                        player.scalingMode = MPMovieScalingModeAspectFill;
                        [cell.contentView addSubview:player.view];
                    }];
                });
            }
        };
        [self presentMHGalleryController:gallery animated:YES completion:nil];
}

-(void)AddComment:(id)sender
{
    Media *media = [self.tableItems objectAtIndex:((UIButton*)sender).tag];
    self.newsID = media.ID;
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
//    if ([segue.identifier isEqualToString:@"addcomment"]) {
//        CommentViewController *destination = [segue destinationViewController];
//        destination.mediaID = self.newsID;
//    }

}

@end
