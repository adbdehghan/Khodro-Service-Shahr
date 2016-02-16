//
//  NewsDetailViewController.m
//  Khodro service shahr
//
//  Created by aDb on 2/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "NewsDetailViewController.h"
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

static NSString *const ServerURL = @"http://khodroservice.kara.systems";
static NSString *const cellIdentifier = @"identifier";
static NSString *const menuCellIdentifier = @"rotationCell";


@interface NewsDetailViewController ()<UIScrollViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}
@property(nonatomic,strong) NSMutableArray *galleryDataSource;
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, strong) NSMutableArray *tableItems;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *newsLiked;
@property (nonatomic, strong) UIBarButtonItem *filterBarButton;
@property (nonatomic) NJKScrollFullScreen *scrollProxy;
@property (nonatomic,strong)User *user;


@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.user = app.user;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [activityIndicator startAnimating];
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:250/255.f alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text= @"جزيیات";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    

    self.images = [[NSMutableArray alloc]init];
    self.tableItems = [[NSMutableArray alloc]init];
    self.newsLiked = [[NSMutableArray alloc]init];
    self.galleryDataSource = [[NSMutableArray alloc]init];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    
    barButtonItem.tintColor = [UIColor whiteColor];
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    

}

-(void)requestData
{
    
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
                News *news = [News modelFromJSONDictionary:(NSDictionary*)data];
                
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
    
    
    [self.getData GetEventByID:self.news.ID withCallback:callback];
    

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)controlTappedAtIndex:(int)index Sender:(id)sender
{
    if (self.user != nil) {
        
        
        NSLog(@"index at %d tapped", index);
        NSLog(@"tag: %ld tapped", (long)((PicsLikeControl*)(sender)).tag);
        
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        
        NewsTableViewCell *cell=[self.tableView cellForRowAtIndexPath:hitIndex];
        
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




- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width-30, 20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}


- (void)setUpCell:(NewsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    News *news = [self.tableItems objectAtIndex:indexPath.section];
    
    cell.titleLabel.text = news.Title;
    cell.descriptionLabel.text = news.Detail;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.itemSize = CGSizeMake(self.view.frame.size.width - 20, 225);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cell.collectionView.collectionViewLayout = layout;
    
    [cell.collectionView registerClass:[MHMediaPreviewCollectionViewCell class] forCellWithReuseIdentifier:@"MHMediaPreviewCollectionViewCell"];
    
    cell.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    cell.collectionView.backgroundColor = [UIColor clearColor];
    [cell.collectionView setShowsHorizontalScrollIndicator:NO];
    [cell.collectionView setDelegate:self];
    [cell.collectionView setDataSource:self];
    [cell.collectionView setTag:indexPath.section];
    [cell.collectionView reloadData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    cell.backgroundColor =[UIColor clearColor];

}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    [sizingCell setNeedsDisplay];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    return size.height;
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.itemSize = CGSizeMake(self.view.frame.size.width - 20, 225);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cell.collectionView.collectionViewLayout = layout;
    
    [cell.collectionView registerClass:[MHMediaPreviewCollectionViewCell class] forCellWithReuseIdentifier:@"MHMediaPreviewCollectionViewCell"];
    
    cell.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    cell.collectionView.backgroundColor = [UIColor clearColor];
    [cell.collectionView setShowsHorizontalScrollIndicator:NO];
    [cell.collectionView setDelegate:self];
    [cell.collectionView setDataSource:self];
    [cell.collectionView setTag:indexPath.section];
    [cell.collectionView reloadData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    cell.backgroundColor =[UIColor clearColor];
    
    return cell;
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
    
    UIImageView *imageView = [(MHMediaPreviewCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath] thumbnail];
    
    NSArray *galleryData = self.galleryDataSource[collectionView.tag];
    
    MHGalleryController *gallery = [MHGalleryController galleryWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarShown];
    gallery.galleryItems = galleryData;
    gallery.presentingFromImageView = imageView;
    gallery.presentationIndex = indexPath.row;

    gallery.UICustomization.hideShare = YES;
    gallery.galleryDelegate = self;
    //gallery.dataSource = self;
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

@end
