//
//  ٍResetPasswordViewController.m
//  Hyper Me
//
//  Created by aDb on 10/22/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import "ٍResetPasswordViewController.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "UIWindow+YzdHUD.h"

@interface _ResetPasswordViewController ()

{
    Settings *st;
    
}
@property (strong, nonatomic) DataDownloader *getData;

@end

@implementation _ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationBar];
    
    rules.font = [UIFont fontWithName:@"B Yekan+" size:15];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ResetPassword:(id)sender
{
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💭"
                                                            message:[((NSMutableDictionary*)data) objectForKey:@"res"]
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
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
 
    if ([usernameTextField.text length]>0) {
    
        [self.getData ResetPassword:usernameTextField.text withCallback:callback];
         [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"❗️"
                                                        message:@"لطفا شماره همراه را وارد کنید"
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        
        [alert show];
    
    }
    
}

- (void)CustomizeNavigationBar
    {
        
        UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
        label.text=self.navigationItem.title;
        label.textColor=[UIColor whiteColor];
        label.backgroundColor =[UIColor clearColor];
        label.adjustsFontSizeToFitWidth=YES;
        label.font = [UIFont fontWithName:@"B Yekan+" size:17];
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView=label;
        
        
        UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:0];
        
        
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
    
    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        //    [nameUiTextField resignFirstResponder];
        //    [familyCodeUiTextField resignFirstResponder];
        [self.view endEditing:YES];
        
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
