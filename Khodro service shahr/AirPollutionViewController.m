//
//  AirPollutionViewController.m
//  Khodro service shahr
//
//  Created by aDb on 1/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "AirPollutionViewController.h"

@interface AirPollutionViewController ()

@end

@implementation AirPollutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;

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
