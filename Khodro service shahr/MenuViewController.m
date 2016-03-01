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

@interface MenuViewController ()
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
    

    GetAd *ad = [[GetAd alloc]init];
    [ad CheckAd];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(Adver:) name:@"AD" object:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(notify:) name:@"menu" object:nil];
}

-(void)Adver:(NSNotification *)notification{

    AdViewController *adController =[[AdViewController alloc]init];
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:adController];
    self.animator.dragable = YES;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 0.5f;
    self.animator.behindViewScale = 0.7f;
    self.animator.transitionDuration = 0.7f;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    adController.transitioningDelegate = self.animator;
    adController.modalPresentationStyle = UIModalPresentationCustom;
    [self.animator setContentScrollView:adController.scrollView];
    
    if (!app.adShown) {
        app.adShown = YES;
        [self presentViewController:adController animated:YES completion:nil];
    }
    
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

@end

