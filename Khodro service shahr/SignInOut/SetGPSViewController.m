//
//  SetGPSViewController.m
//  Khodro service shahr
//
//  Created by aDb on 2/7/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "SetGPSViewController.h"
#import "DataDownloader.h"
#import "UIWindow+YzdHUD.h"
#import "AppDelegate.h"

@interface SetGPSViewController ()
@property (nonatomic,strong)User *user;
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation SetGPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationBar];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.user = app.user;
    
    NSMutableArray *Serial = [self loadSerial];
    
    if (Serial.count>0) {
        serialTextField.text = Serial[0];
        simcardTextField.text = Serial[1];
    }
}

- (IBAction)ResetPassword:(id)sender
{
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💭"
                                                            message:@"با موفقیت انجام شد"
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
            [self Save];
            
        }
        
        else
        {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"❗️"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید"
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
    };
    
    if ([serialTextField.text length]>0 && [simcardTextField.text length]>0) {
        
        [self.getData SetGpsDevice:self.user.mobile Password:self.user.password ime:serialTextField.text simcard:simcardTextField.text withCallback:callback];
        [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"❗️"
                                                        message:@"لطفا مقادیر ورودی را بررسی نمایید"
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    
}

-(NSMutableArray*)loadSerial
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"serial.plist"];
    
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    return array;
}

- (void)Save
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:serialTextField.text];
    [array addObject:simcardTextField.text];
    //
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"serial.plist"];
    
    [array writeToFile:plistPath atomically: TRUE];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
