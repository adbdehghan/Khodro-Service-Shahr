//
//  SignInViewController.m
//  Hyper Me
//
//  Created by aDb on 10/15/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import "SignInViewController.h"
#import "DataDownloader.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "UIWindow+YzdHUD.h"
#import "ProfileTableViewController.h"
#import "AppDelegate.h"

@interface SignInViewController ()<UITextFieldDelegate>
{
    User *user;
}
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationBar];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"وارد شوید";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font =[UIFont fontWithName:@"B Yekan+" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:0];
    
    // Associate the barButtonItem to the previous view
    previousVC.navigationItem.titleView = label;
    
    [self CreateMenuButton:previousVC.navigationItem];
    
    self.navigationItem.hidesBackButton = YES;

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(IBAction)SignIn:(id)sender
{
    
    if ([usernameTextField.text length]>0 && [passwordTextField.text length]>0) {
        
        RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
            if (wasSuccessful) {
                
                if (data != nil) {
                    
                    user = [User modelFromJSONDictionary:(NSDictionary*)data]; 
                    user.password = passwordTextField.text;
                    user.username = usernameTextField.text;
                    [self Save:user];
                    
                    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                    
                    app.user = user;
                    
                     [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                    [self performSegueWithIdentifier:@"profile" sender:self];
                }
                
                else
                {
                     [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"❗️"
                                                                    message:@"نام کاربری یا کلمه ی عبور اشتباه است"
                                                                   delegate:self
                                                          cancelButtonTitle:@"تایید"
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                
                }
                
                
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
        
        [self.getData SignIn:usernameTextField.text Password:passwordTextField.text withCallback:callback];
        [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"❗️"
                                                        message:@"نام کاربری / کلمه ی عبور خود را وارد نمایید!"
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        
        [alert show];
        
    
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

- (void)Save:(User*)branch
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSString stringWithFormat:@"%@",branch.itemId]];
    [array addObject:[NSString stringWithFormat:@"%@ %@",branch.name,branch.lastname]];
    [array addObject:branch.mobile];
    [array addObject:branch.password];
    [array addObject:branch.PicThumb];
    //
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    
    [array writeToFile:plistPath atomically: TRUE];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)CustomizeNavigationBar
{
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"وارد شوید";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font =[UIFont fontWithName:@"B Yekan+" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
   
    
}

-(void)CreateMenuButton:(UINavigationItem*)navigationItem
{
    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingImage = [[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuButton setImage:settingImage forState:UIControlStateNormal];
    
    menuButton.tintColor = [UIColor whiteColor];
    [menuButton addTarget:self action:@selector(GoToMenu)forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 24, 24)];
    
    
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    navigationItem.leftBarButtonItem = settingBarButton;
    
    
}

-(void)GoToMenu
{
    
    [self performSegueWithIdentifier:@"first" sender:self];
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
