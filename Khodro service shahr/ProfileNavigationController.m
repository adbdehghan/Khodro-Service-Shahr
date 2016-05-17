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
    UIViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"login"];

    NSMutableArray *userData =  [self load]; 

    if (userData.count >0) {

    }
    else
    {
        UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
        label.text=@"وارد شوید";
        label.textColor=[UIColor whiteColor];
        label.backgroundColor =[UIColor clearColor];
        label.adjustsFontSizeToFitWidth=YES;
        label.font =[UIFont fontWithName:@"B Yekan+" size:17];
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView=label;
        
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
