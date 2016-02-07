//
//  CommentViewController.m
//  Khodro service shahr
//
//  Created by aDb on 2/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "CommentViewController.h"
#import "DataDownloader.h"
#import "Comment.h"
#import "MBJSONModel.h"
#import "CommentTableViewCell.h"
#import "UIImageView+Letters.h"
#import "AppDelegate.h"
#import "User.h"

@interface CommentViewController ()<UITableViewDataSource, UITableViewDelegate>
{

    UIView *responseView;
    UITextField *responseTextField;
    UIButton *sendButton;
    UIActivityIndicatorView *activityIndicator;
    UITableView* commentsTableView;
    NSMutableArray *commentsArray;
}
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic,strong)User *user;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    self.user = app.user;
    
    commentsArray = [[NSMutableArray alloc]init];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [activityIndicator startAnimating];
    
    commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-100)];
    commentsTableView.delegate = self;
    commentsTableView.dataSource = self;
    commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:commentsTableView];
    
    responseView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(commentsTableView.frame), self.view.frame.size.width, 40)];
    responseView.backgroundColor = [UIColor colorWithRed:100/255.f green:184/255.f blue:34/255.f alpha:1];
    [self.view addSubview:responseView];
    
    responseTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 5, responseView.frame.size.width-78, 30)];
    responseTextField.placeholder = @"";
    responseTextField.backgroundColor = [UIColor whiteColor];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    responseTextField.rightView = paddingView;
    responseTextField.rightViewMode = UITextFieldViewModeAlways;
    [responseTextField setTextAlignment:NSTextAlignmentRight];
    [responseView addSubview:responseTextField];
    responseTextField.delegate = self;
    
    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 55, 30)];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:@"ارسال" forState:UIControlStateNormal];
    sendButton.titleLabel.font =[UIFont fontWithName:@"B Yekan+" size:19];
    [sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [responseView addSubview:sendButton];
    
   
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"نظرات";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    
    barButtonItem.tintColor = [UIColor whiteColor];
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];

    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                Comment *comment = [Comment modelFromJSONDictionary:item];
                [commentsArray addObject:comment];
                
                
            }
            
            [commentsTableView reloadData];
            [activityIndicator stopAnimating];

            
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
    

    

    
    
       if (self.newsID != nil) {
           [self.getData GetEventComments:self.newsID  withCallback:callback];
       }
       else{
           [self.getData GetMediaComments:self.mediaID  withCallback:callback];
       }

    
}



- (void) sendComment {
    if (self.user != nil) {
     
    if (responseTextField.text.length>0 ) {
        

        [activityIndicator startAnimating];
        
        RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
            if (wasSuccessful) {
                
                [activityIndicator stopAnimating];
                
         
                
              //  [commentsArray addObject:responseTextField.text];
              //  [commentsTableView reloadData];
//                [activityIndicator stopAnimating];
//                [self.tableView reloadData];
                
                
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
        
        

        
        
        if (self.newsID != nil) {
        [self.getData AddComment:self.user.mobile Password:self.user.password eventID:self.newsID Comment:responseTextField.text  withCallback:callback];
        }
        else
            [self.getData AddCommentMedia:self.user.mobile Password:self.user.password eventID:self.mediaID Comment:responseTextField.text  withCallback:callback];

        
    }
    }
    else
    {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                        message:@"برای ارسال نظر ابتدا وارد شوید"
                                                       delegate:self
                                              cancelButtonTitle:@"خب"
                                              otherButtonTitles:nil];
        [alert show];
    
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"commentCell";
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    Comment *comment = (Comment*)[commentsArray objectAtIndex:indexPath.row];
    
    cell.usernameLabel.text = comment.userID;
    cell.commentLabel.text = comment.Comment;
    

        
    [cell.userImage setImageWithString:comment.userID color:[UIColor colorWithRed:100/255.f green:184/255.f blue:34/255.f alpha:1] circular:YES];


    return cell;
}

- (UIImage *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    UIImage *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentsArray.count;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Register Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark KEYBOARD NOTIFICATIONS

- (void) keyboardWillShow:(NSNotification *)note
{
    NSDictionary *keyboardAnimationDetail = [note userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    NSValue* keyboardFrameBegin = [keyboardAnimationDetail valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    int keyboardHeight = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) ? keyboardFrameBeginRect.size.height : keyboardFrameBeginRect.size.width;
    
    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
       // commentsTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-keyboardHeight);
        responseView.frame = CGRectMake(0, self.view.frame.size.height-40-keyboardHeight, self.view.frame.size.width, 40);
    } completion:^(BOOL finished) {
        [commentsTableView scrollRectToVisible:CGRectMake(0, commentsTableView.contentSize.height-1, 1, 1) animated:YES];
    }];
}

- (void) keyboardWillHide:(NSNotification *)note
{
    NSDictionary *keyboardAnimationDetail = [note userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
      //  commentsTableView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-100);
        responseView.frame = CGRectMake(0, CGRectGetMaxY(commentsTableView.frame), self.view.frame.size.width, 40);
    } completion:^(BOOL finished) {
        [commentsTableView scrollRectToVisible:CGRectMake(0, commentsTableView.contentSize.height-1, 1, 1) animated:YES];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [nameUiTextField resignFirstResponder];
    //    [familyCodeUiTextField resignFirstResponder];
    [responseTextField resignFirstResponder];
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

@end
