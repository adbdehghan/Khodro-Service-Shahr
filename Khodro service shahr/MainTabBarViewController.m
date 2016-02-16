//
//  MainTabBarViewController.m
//  Khodro service shahr
//
//  Created by aDb on 12/9/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "BROptionsButton.h"
#import "GetAd.h"
#import "AdViewController.h"
#import "AppDelegate.h"


@interface MainTabBarViewController ()<BROptionButtonDelegate>
{
    BROptionsButton *brOption ;
    AppDelegate *app;
}
@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    brOption = [[BROptionsButton alloc] initForTabBar:self.tabBar forItemIndex:2 delegate:self];
    
    [brOption setImage:[UIImage imageNamed:@"menu"] forBROptionsButtonState:BROptionsButtonStateNormal];
    [brOption setImage:[UIImage imageNamed:@"close"] forBROptionsButtonState:BROptionsButtonStateOpened];
    [self setSelectedIndex:[self.MenuSelectedIndex integerValue]];

    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(notify:) name:@"AD" object:nil];
    
    GetAd *ad = [[GetAd alloc]init];
    [ad CheckAd];
}


-(void)notify:(NSNotification *)notification{
    
    AdViewController *adController =[[AdViewController alloc]init];
    if (!app.adShown) {

        app.adShown = YES;
        [self presentViewController:adController animated:YES completion:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BROptionsButtonState

- (NSInteger)brOptionsButtonNumberOfItems:(BROptionsButton *)brOptionsButton
{
    return 5;
}

- (UIImage*)brOptionsButton:(BROptionsButton *)brOptionsButton imageForItemAtIndex:(NSInteger)index
{
    UIImage *image ;
    
    switch (index) {
//        case 0:
//            image = [UIImage imageNamed:@"mMedia"];
//            break;
        case 0:
            image = [UIImage imageNamed:@"mMedia"];
            break;
        case 1:
            image = [UIImage imageNamed:@"mTest"];
            break;
        case 2:
            image = [UIImage imageNamed:@"mMap"];
            break;
        case 3:
            image = [UIImage imageNamed:@"mProfile"];
            break;
        case 4:
            image = [UIImage imageNamed:@"mAbout"];
            break;
        default:
            break;
    }
    
    return image;
}


- (void)brOptionsButton:(BROptionsButton *)brOptionsButton didSelectItem:(BROptionItem *)item
{
    [self setSelectedIndex:item.index];
}


@end
