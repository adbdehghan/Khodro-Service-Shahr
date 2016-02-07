//
//  NewsDetailViewController.m
//  Khodro service shahr
//
//  Created by aDb on 2/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "MDCParallaxView.h"
#import "DataDownloader.h"
#import "MBJSONModel.h"
#import "LCBannerView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "CommentViewController.h"
#import "NewsMedia.h"
static NSString *const ServerURL = @"http://khodroservice.kara.systems";
@interface NewsDetailViewController ()<UIScrollViewDelegate,LCBannerViewDelegate>

@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, strong) NSMutableArray *tableItems;
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Creates a marker in the center of the map.
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"خبر";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    
    barButtonItem.tintColor = [UIColor whiteColor];
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    

    
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            [self.tableItems removeAllObjects];

      
                
            News *news = [News modelFromJSONDictionary:(NSDictionary*)data];
            
            UIImage *backgroundImage = [UIImage imageNamed:@"image.png"];
            CGRect backgroundRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), backgroundImage.size.height);
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
            backgroundImageView.image = backgroundImage;
            
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), backgroundImage.size.height)];
            
            NSMutableArray *URLs = [[NSMutableArray alloc]init];
            
            for (NewsMedia *item in news.Medias) {
                if ([item.MIMEType isEqualToString:@"image"]) {
                NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.Url];
                [URLs addObject:fullURL];
                }
            }
            int time = 4;
            
            if (URLs.count == 1)
                time = 0;
            
            if (URLs.count > 0) {
                
                
                
                [backgroundImageView sd_setImageWithURL:URLs[0]];
                
                
                [headerView addSubview:({
                    
                    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 320)
                                                                        delegate:self
                                                                       imageURLs:URLs
                                                                placeholderImage:nil
                                                                   timerInterval:time
                                                   currentPageIndicatorTintColor:[UIColor greenColor]
                                                          pageIndicatorTintColor:[UIColor whiteColor]];
                    bannerView;
                })];
                
            }
            
            backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
            
            UITapGestureRecognizer *tapGesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [backgroundImageView addGestureRecognizer:tapGesture];
            
            CGRect textRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 400.0f);
            UITextView *textView = [[UITextView alloc] initWithFrame:textRect];
            textView.text = NSLocalizedString(news.Detail, nil);
            textView.textAlignment = NSTextAlignmentRight;
            textView.font = [UIFont fontWithName:@"B Yekan+" size:19];
            textView.textColor = [UIColor darkTextColor];
            textView.scrollsToTop = NO;
            textView.editable = NO;
            
            MDCParallaxView *parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:headerView
                                                                             foregroundView:textView];
            parallaxView.frame = self.view.bounds;
            parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            parallaxView.backgroundHeight = 320.0f;
            parallaxView.scrollView.scrollsToTop = YES;
            parallaxView.backgroundInteractionEnabled = YES;
            parallaxView.scrollViewDelegate = self;
            [self.view addSubview:parallaxView];

          
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
