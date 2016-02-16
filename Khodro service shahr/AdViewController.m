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

static NSString *const ServerURL = @"http://khodroservice.kara.systems";

@interface AdViewController ()
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.frame];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.backgroundColor = [UIColor blackColor];
    [self.view addSubview:image];
    
    [self CreateMenuButton];

    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
            
            NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,[((NSDictionary*)data) objectForKey:@"Url"]];
            
            [image sd_setImageWithURL:[NSURL URLWithString:fullURL]];
            
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
