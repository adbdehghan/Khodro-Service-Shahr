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


@interface MenuViewController ()
{
    UIView *thisMenu;
}
@property (nonatomic) BOOL viewIsIn;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *balloonHandler = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x - 55, 19, 4, 1)];
    
    AIMBalloon *balloonView = [AIMBalloon alloc];
    [balloonView Create:self.view linkedToView:balloonHandler image:[UIImage imageNamed:@"map"] size:11 tag:2];


//    UIView *balloonHandler2 = [[UIView alloc]initWithFrame:CGRectMake(90, 60, 4, 1)];
//    
//    AIMBalloon *balloonView2 = [AIMBalloon alloc];
//    [balloonView2 Create:self.view linkedToView:balloonHandler2 image:[UIImage imageNamed:@"media.png"] size:5 tag:0];


    UIView *balloonHandler3 = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x, 19, 4, 1)];
    
    AIMBalloon *balloonView3 = [AIMBalloon alloc];
    [balloonView3 Create:self.view linkedToView:balloonHandler3 image:[UIImage imageNamed:@"about"] size:18 tag:4];


    UIView *balloonHandler4 = [[UIView alloc]initWithFrame:CGRectMake( 55,19, 4, 1)];

    AIMBalloon *balloonView4 = [AIMBalloon alloc];

    [balloonView4 Create:self.view linkedToView:balloonHandler4 image:[UIImage imageNamed:@"media"] size:4 tag:0];


    
    UIView *balloonHandler5 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60,19, 4, 1)];
    
    AIMBalloon *balloonView5 = [AIMBalloon alloc];

    [balloonView5  Create:self.view linkedToView:balloonHandler5 image:[UIImage imageNamed:@"profile"] size:9 tag:3];


    
    UIView *balloonHandler6 = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x + 60, 19, 4, 1)];
    
    AIMBalloon *balloonView6 = [AIMBalloon alloc];
    [balloonView6 Create:self.view linkedToView:balloonHandler6 image:[UIImage imageNamed:@"test"] size:13 tag:1];
    
    
//    UIView *balloonHandler7 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 90, 20, 4, 1)];
//    
//    AIMBalloon *balloonView7 = [AIMBalloon alloc];
//    [balloonView7 Create:self.view linkedToView:balloonHandler7 image:[UIImage imageNamed:@"link"] size:19 tag:5];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(notify:) name:@"menu" object:nil];
}

-(void)notify:(NSNotification *)notification{
    
    self.MenuSelectedIndex =[NSNumber numberWithInteger:((UIButton*)[[notification userInfo] valueForKey:@"button"]).tag];
    if ([self.MenuSelectedIndex integerValue]== 6) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://2.144.197.202/fish.aspx"]];
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
    
        MainTabBarViewController *destination = [segue destinationViewController];
        destination.MenuSelectedIndex = self.MenuSelectedIndex;
}

@end

