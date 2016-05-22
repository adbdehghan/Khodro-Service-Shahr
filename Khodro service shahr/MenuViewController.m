//
//  MenuViewController.m
//  Khodro service shahr
//
//  Created by aDb on 1/18/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "MenuViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIView+Genie.h"
#import "AIMBalloon.h"
#import "MainTabBarViewController.h"
#import "GetAd.h"
#import "AdViewController.h"
#import "AppDelegate.h"
#import "ZFModalTransitionAnimator.h"
#import "AboutMainViewController.h"
#import "SFDraggableDialogView.h"
#import "UIImageView+WebCache.h"

static NSString *const ServerURL = @"http://khodroservice.kara.systems";
@interface MenuViewController ()<SFDraggableDialogViewDelegate>
{
    UIView *thisMenu;
    float location;
    AppDelegate *app;
    NSInteger ropeSize;
}
@property (nonatomic) BOOL viewIsIn;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ropeSize = 18;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.view.frame.size.height == 480) {
        self.secondImage.image = [UIImage imageNamed:@"greeting4s"];
        ropeSize = 13;
    }
    
    location = self.view.frame.size.width/8;
    
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    UIView *balloonHandler = [[UIView alloc]initWithFrame:CGRectMake(3*location, 19, 4, 1)];
    
    AIMBalloon *balloonView = [AIMBalloon alloc];
    [balloonView Create:self.view linkedToView:balloonHandler image:[UIImage imageNamed:@"map"] size:11 tag:3];
    
    
    UIView *balloonHandler2 = [[UIView alloc]initWithFrame:CGRectMake(2*location, 19, 4, 1)];
    
    AIMBalloon *balloonView2 = [AIMBalloon alloc];
    [balloonView2 Create:self.view linkedToView:balloonHandler2 image:[UIImage imageNamed:@"media.png"] size:4 tag:1];
    
    
    UIView *balloonHandler3 = [[UIView alloc]initWithFrame:CGRectMake(4*location, 19, 4, 1)];
    
    AIMBalloon *balloonView3 = [AIMBalloon alloc];
    [balloonView3 Create:self.view linkedToView:balloonHandler3 image:[UIImage imageNamed:@"about"] size:ropeSize tag:5];
    
    
    UIView *balloonHandler4 = [[UIView alloc]initWithFrame:CGRectMake( location,19, 4, 1)];
    
    AIMBalloon *balloonView4 = [AIMBalloon alloc];
    
    [balloonView4 Create:self.view linkedToView:balloonHandler4 image:[UIImage imageNamed:@"news"] size:12 tag:0];
    
    
    
    UIView *balloonHandler5 = [[UIView alloc]initWithFrame:CGRectMake(6*location,19, 4, 1)];
    
    AIMBalloon *balloonView5 = [AIMBalloon alloc];
    
    [balloonView5  Create:self.view linkedToView:balloonHandler5 image:[UIImage imageNamed:@"profile"] size:9 tag:4];
    
    
    
    UIView *balloonHandler6 = [[UIView alloc]initWithFrame:CGRectMake(5*location, 19, 4, 1)];
    
    AIMBalloon *balloonView6 = [AIMBalloon alloc];
    [balloonView6 Create:self.view linkedToView:balloonHandler6 image:[UIImage imageNamed:@"test"] size:6 tag:2];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(Adver:) name:@"AD" object:nil];
    GetAd *ad = [[GetAd alloc]init];
    [ad CheckAd];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(notify:) name:@"menu" object:nil];
}

-(void)Adver:(NSNotification *)notification{
    
    
    NSDictionary *dict = [notification userInfo];
    
    if ([dict objectForKey:@"data"] != [NSNull null]) {
        
        NSDictionary *data = [dict objectForKey:@"data"];
        data = [data objectForKey:@"data"];
        SFDraggableDialogView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"SFDraggableDialogView" owner:self options:nil] firstObject];
        dialogView.frame = self.view.bounds;
        
        NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,[data objectForKey:@"Url"]];
        UIImageView *image =[[UIImageView alloc]init];
        NSURL *url =[NSURL URLWithString:fullURL];
        
        
        if (!app.adShown) {
            app.adShown = YES;
            
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {

             }
                                                              completed:^(UIImage *image, NSData *data2, NSError *error, BOOL finished)
             {
                 if (image && finished)
                 {
                     dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                         //Background Thread
                         dispatch_async(dispatch_get_main_queue(), ^(void){
                             dialogView.photo = image;
                             dialogView.delegate = self;
                             dialogView.titleText = [[NSMutableAttributedString alloc] initWithString:[data objectForKey:@"Title"]];
                             dialogView.messageText =[[NSMutableAttributedString alloc]initWithString:[data objectForKey:@"Comment"]];
                             
                             dialogView.firstBtnText = [@"تایید" uppercaseString];
                             dialogView.dialogBackgroundColor = [UIColor whiteColor];
                             dialogView.cornerRadius = 8.0;
                             dialogView.backgroundShadowOpacity = 0.2;
                             dialogView.hideCloseButton = true;
                             dialogView.showSecondBtn = false;
                             dialogView.contentViewType = SFContentViewTypeDefault;
                             dialogView.firstBtnBackgroundColor = [UIColor colorWithRed:0.230 green:0.777 blue:0.316 alpha:1.000];
                             [dialogView createBlurBackgroundWithImage:[self jt_imageWithView:self.view] tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.35] blurRadius:60.0];
                             
                             [self.view addSubview:dialogView];
                         });
                     });
                     
                 }
             }];
        }
    }
}

- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressFirstButton:(UIButton *)firstButton
{
//    self.MenuSelectedIndex = [NSNumber numberWithInteger:2];
//    [self NextBoard];
    [dialogView dismissWithDrop:YES];
}

-(void)notify:(NSNotification *)notification{
    
    self.MenuSelectedIndex =[NSNumber numberWithInteger:((UIButton*)[[notification userInfo] valueForKey:@"button"]).tag];
    if ([self.MenuSelectedIndex integerValue]== 5) {
        [self performSegueWithIdentifier:@"about" sender:self];
    }
    else
        [self NextBoard];
}


-(void)PrepareForNextBoard
{
    [self performSelector:@selector(NextBoard) withObject:nil afterDelay:.14];
}

-(void)NextBoard
{
    [self performSegueWithIdentifier:@"tomain" sender:self];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.identifier isEqualToString:@"about"]) {
        MainTabBarViewController *destination = [segue destinationViewController];
        destination.MenuSelectedIndex = self.MenuSelectedIndex;
    }
    
    
}

#pragma mark - Snapshot
- (UIImage *)jt_imageWithView:(UIView *)view {
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:true];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

