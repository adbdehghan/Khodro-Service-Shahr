//
//  ProfileNavigationController.m
//  Khodro service shahr
//
//  Created by aDb on 2/5/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "ProfileNavigationController.h"
#import "ProfileTableViewController.h"
#import "SignInViewController.h"

@interface ProfileNavigationController ()

@end

@implementation ProfileNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *profile = [storyboard instantiateViewControllerWithIdentifier:@"profile"];
  //  UIViewController *setGPS = [storyboard instantiateViewControllerWithIdentifier:@"setGPS"];
    UIViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    //UIViewController *registerClient = [storyboard instantiateViewControllerWithIdentifier:@"register"];
    

    
    NSMutableArray *userData =  [self load];
    
    if (userData.count >0) {

//        [self setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
     //   [self addChildViewController:profile];

        //[self addChildViewController:setGPS];

    }
    else
    {
        [self addChildViewController:login];
      //  [self addChildViewController:registerClient];
    
    }
    
}

-(NSMutableArray*)load
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
