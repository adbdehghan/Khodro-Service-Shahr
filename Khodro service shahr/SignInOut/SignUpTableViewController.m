//
//  SignUpTableViewController.m
//  Hyper Me
//
//  Created by aDb on 10/16/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import "SignUpTableViewController.h"
#import "Settings.h"
#import "DBManager.h"
#import "SignupTableViewCell.h"
#import "DataDownloader.h"
#import "UIWindow+YzdHUD.h"
#import "ProfileTableViewController.h"
#import "User.h"

@interface SignUpTableViewController ()
{
    User *user;
    Settings *st;
    SignupTableViewCell *firstCell;
    NSMutableArray *allcell;
}
@property (strong, nonatomic) DataDownloader *getData;
@end


@implementation SignUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    user = [User alloc];
    allcell = [[NSMutableArray alloc]init];
    
    [self CustomizeNavigationBar];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    st = [[Settings alloc]init];
    
    for (Settings *item in [DBManager selectSetting])
    {
        st =item;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"floor.png"]];
    [tempImageView setFrame:self.tableView.frame];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    tempImageView.alpha = .9;
    
    self.tableView.backgroundView = tempImageView;
    
    
}

-(IBAction)Signup:(id)sender
{
    
    NSString *name;
    NSString  *lastname;
    NSString  *mobileNumber;
    NSString *username;
    NSString *password;
    NSString *email;

    
    int i = 0;
    
    for (SignupTableViewCell *cell in allcell)
    {
        

            
        switch (i) {
            case 0:
                name = cell.name.text;
                break;
            case 1:
                lastname = cell.lastname.text;
                break;
            case 2:
                mobileNumber = cell.mobileNumber.text;
                break;
            case 3:
                email = cell.email.text;
                break;
            case 4:
                username = cell.username.text;
                break;
            case 5:
                password = cell.password.text;
                break;
                
        }
        i++;
    
    }
        RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
            if (wasSuccessful) {
                
                NSDictionary *temp = (NSMutableDictionary*)data;
                   [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                if ([[NSString stringWithFormat:@"%@",[temp valueForKey:@"status"]] isEqualToString:@"1"]) {
                    
                    
                    user.name = name;
                    user.lastname = lastname;
                    user.password = password;
                    user.email = email;
                    user.username = username;
                    user.mobile = mobileNumber;
                    
                    [self Save:user];
                    
                 
                    
                    [self performSegueWithIdentifier:@"profile" sender:self];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"❗️"
                                                                    message:[temp valueForKey:@"data"]
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
    
    if (name.length >0 && lastname.length >0 && mobileNumber.length >0 && username.length >0 && password.length >0)
    {
        NSMutableArray *tokenArray = [self load];
        NSString *token;
        if (tokenArray.count>0) {
            token = [tokenArray objectAtIndex:0];
        }
        
        [self.getData SignUp:name Lastname:lastname MobileNumber:mobileNumber  Username:username Password:password Email:email deviceID:token devType:@"2" withCallback:callback];
           [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"❗️"
                                                        message:@"لطفا فیلدهای اجباری را پر کنید"
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
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"token.plist"];
    
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
//
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    
    [array writeToFile:plistPath atomically: TRUE];
    
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSString *cellIdentifier = [NSString stringWithFormat:@"CellIdentifier%ld",(long)indexPath.row];
    

    SignupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [allcell addObject:cell];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}


- (void)CustomizeNavigationBar
{
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
    
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    
    barButtonItem.tintColor = [UIColor whiteColor];
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    
    
    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setTitle:@"ثبت"  forState:UIControlStateNormal];
    [menuButton.titleLabel setFont:[UIFont fontWithName:@"B Yekan+" size:19]];
    menuButton.titleLabel.textColor = [UIColor orangeColor];
    menuButton.tintColor = [UIColor orangeColor];
    [menuButton addTarget:self action:@selector(Signup:)forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 35, 24)];
    
    
    UIBarButtonItem *signupButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    signupButton.tintColor = [UIColor orangeColor];
    
    [self.navigationItem setRightBarButtonItem:signupButton];
    
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
