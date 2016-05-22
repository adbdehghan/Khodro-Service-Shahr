//
//  PDFViewController.m
//  Khodro service shahr
//
//  Created by adb on 5/23/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController ()

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CustomizeNavigationBar];
    
    NSURL *targetURL = [NSURL URLWithString:self.pdfUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    
    [webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
}


- (void)CustomizeNavigationBar
{
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font =[UIFont fontWithName:@"B Yekan+" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    
    barButtonItem.tintColor = [UIColor whiteColor];
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    
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
