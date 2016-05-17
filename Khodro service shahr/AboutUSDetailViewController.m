//
//  AboutUSDetailViewController.m
//  Khodro service shahr
//
//  Created by aDb on 2/14/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "AboutUSDetailViewController.h"

@interface AboutUSDetailViewController ()
{

}
@end

@implementation AboutUSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadAboutUS];
 
}

-(void)LoadAboutUS
{
    NSString *fileName;
    NSString *headerName;
    UIColor *statusBarColor;
    
    switch (self.menuID) {
        case 1:
        {
            fileName = @"history";
            headerName =@"top2";
            statusBarColor = [UIColor colorWithRed:247/255.f green:156/255.f blue:128/255.f alpha:1];
        }
            break;
        case 0:
        {
            fileName = @"2";
            headerName =@"top3";
            statusBarColor = [UIColor colorWithRed:176/255.f green:204/255.f blue:145/255.f alpha:1];

        }
            break;
        case 2:
        {
            fileName = @"1";
            headerName =@"top5";
            statusBarColor = [UIColor colorWithRed:242/255.f green:166/255.f blue:84/255.f alpha:1];

        }
            break;
        case 3:
        {
            fileName = @"3";
            headerName =@"top4";
            statusBarColor = [UIColor colorWithRed:82/255.f green:194/255.f blue:173/255.f alpha:1];
        }
            break;
        case 4:
        {
            fileName = @"5";
            headerName =@"top7";
            statusBarColor = [UIColor colorWithRed:161/255.f green:153/255.f blue:214/255.f alpha:1];

        }
            break;
        case 5:
        {
            fileName = @"4";
            headerName =@"top6";
            statusBarColor = [UIColor colorWithRed:245/255.f green:133/255.f blue:130/255.f alpha:1];
        }
            break;
        default:
            break;
    }
    
    self.headerView.image = [UIImage imageNamed:headerName];
    self.statusBar.backgroundColor = statusBarColor;
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)PopView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
