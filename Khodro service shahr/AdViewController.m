//
//  AdViewController.m
//  Khodro service shahr
//
//  Created by aDb on 2/15/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "AdViewController.h"
#import "DataDownloader.h"
#import "UIImageView+WebCache.h"
#import "MDCParallaxView.h"
#import "MZLoadingCircle.h"

static NSString *const ServerURL = @"http://khodroservice.kara.systems";

@interface AdViewController ()<UIScrollViewDelegate>
{
    MZLoadingCircle *loadingCircle;
}
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    loadingCircle = [[MZLoadingCircle alloc]initWithNibName:nil bundle:nil];
    loadingCircle.view.backgroundColor = [UIColor clearColor];
    
    //Colors for layers
    loadingCircle.colorCustomLayer = [UIColor whiteColor];
    loadingCircle.colorCustomLayer2 =[UIColor orangeColor];
    loadingCircle.colorCustomLayer3 = [UIColor whiteColor];
    
    int size = 100;
    
    CGRect frame = loadingCircle.view.frame;
    frame.size.width = size ;
    frame.size.height = size;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2;
    loadingCircle.view.frame = frame;
    loadingCircle.view.layer.zPosition = MAXFLOAT;
    [self.view addSubview: loadingCircle.view];
    
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.frame];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.backgroundColor = [UIColor blackColor];

    self.view.backgroundColor = [UIColor clearColor];

    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
            
            NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,[((NSDictionary*)data) objectForKey:@"Url"]];
            
            UIImage *backgroundImage = image.image;
            
            CGRect backgroundRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300);
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
            //backgroundImageView.image = backgroundImage;
            backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
            [backgroundImageView sd_setImageWithURL:[NSURL URLWithString:fullURL]];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [backgroundImageView addGestureRecognizer:tapGesture];
            
            CGRect textRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 400.0f);
            UITextView *textView = [[UITextView alloc] initWithFrame:textRect];
            textView.text = NSLocalizedString([((NSDictionary*)data) objectForKey:@"Comment"], nil);
            textView.textAlignment = NSTextAlignmentCenter;
            textView.font = [UIFont fontWithName:@"B Yekan+" size:18];
            textView.textColor = [UIColor darkTextColor];
            textView.scrollsToTop = NO;
            textView.editable = NO;
            
            MDCParallaxView *parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:backgroundImageView
                                                                             foregroundView:textView];
            parallaxView.frame = CGRectMake(0, 250, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-250);
            parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            parallaxView.backgroundHeight = 250.0f;
            parallaxView.scrollView.scrollsToTop = YES;
            parallaxView.backgroundInteractionEnabled = YES;
            parallaxView.scrollViewDelegate = self;
            [self.view addSubview:parallaxView];
            [loadingCircle.view removeFromSuperview];
            loadingCircle = nil;
            [self CreateMenuButton];
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
    
    [self.getData GetAd:@""  withCallback:callback];

    
}

-(void)CreateMenuButton
{
    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingImage = [[UIImage imageNamed:@"closeAd.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
   // menuButton.tintColor = [UIColor whiteColor];
    [menuButton addTarget:self action:@selector(CloseView)forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(self.view.frame.size.width - 36, 25, 32, 32)];
    
    [self.view addSubview:menuButton];
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}


#pragma mark - Internal Methods

- (void)handleTap:(UIGestureRecognizer *)gesture {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}


-(void)CloseView
{

    [self dismissViewControllerAnimated:YES completion:nil];

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
