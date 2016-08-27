//
//  NotificationTableViewController.m
//  Khodro service shahr
//
//  Created by adb on 8/26/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "NotificationTableViewController.h"
#import "CustomTableViewCell.h"
#import "DataDownloader.h"
#import "AppDelegate.h"
#import "MBJSONModel.h"
#import "Notification.h"
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface NotificationTableViewController ()
{
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic,strong)User *user;
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end

@implementation NotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 80;
    [self CustomizeView];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [activityIndicator startAnimating];
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.user = app.user;
    
    self.messageList = [[NSMutableArray alloc]init];
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                Notification *notification = [Notification modelFromJSONDictionary:item];
                [self.messageList addObject:notification];
            }
            [activityIndicator stopAnimating];
            [self.tableView reloadData];
        }
        
        else
        {
            [activityIndicator stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"👻"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"خب"
                                                  otherButtonTitles:nil];
            [alert show];
//            [activityIndicator stopAnimating];
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    [self.getData GetNotification:self.user.itemId withCallback:callback];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.estimatedRowHeight = 100;
    
    static NSString *cellIdentifier = @"CellIdentifier";
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    if ([self.messageList  count]>0) {
         NSString *cellText = ((Notification* )[self.messageList objectAtIndex:indexPath.row]).message;
        NSString *dateText =  ((Notification* )[self.messageList objectAtIndex:indexPath.row]).time;
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:cellText];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        //    paragraphStyle.alignment = NSTextAlignmentJustified;    // To justified text
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [cellText length])];
        
        cell.titleLabel.attributedText = attributedString;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dateTimeLabel.font =[UIFont fontWithName:@"B Yekan+" size:13];
        cell.dateTimeLabel.text = [ NSString stringWithFormat:@"%@",dateText];
        cell.dateTimeLabel.textColor = [UIColor whiteColor];
        
        
        if (indexPath.row % 2 == 0) {
            [cell.dateBackground setBackgroundColor:RGBCOLOR(110, 110,110)];
        }
        else
        {
            [cell.dateBackground setBackgroundColor:RGBCOLOR(49, 148,16)];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.titleLabel.textColor=[UIColor blackColor];
        cell.titleLabel.backgroundColor = [UIColor clearColor];
        
        //  cell.background.layer.cornerRadius = 6;
        
        cell.background.clipsToBounds = YES;
        cell.background.backgroundColor = [UIColor whiteColor];
        
        cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.titleLabel.numberOfLines = 0;
        
        
        [cell.titleLabel setTextAlignment:NSTextAlignmentRight];
        [cell.titleLabel setFont:[UIFont fontWithName:@"B Yekan+" size:15]];
        [cell.titleLabel sizeToFit];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
    return cell;
    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.messageList  count]>0) {
        NSString *cellText = ((Notification* )[self.messageList objectAtIndex:indexPath.row]).message;
        
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:cellText];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        //    paragraphStyle.alignment = NSTextAlignmentJustified;    // To justified text
        
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [cellText length])];
        
        UILabel *textLabel = [[UILabel alloc]init];
        
        textLabel.frame =CGRectMake(0, 0,tableView.bounds.size.width - 30 ,9999 );
        
        textLabel.attributedText = attributedString;
        
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.numberOfLines = 0;
        [textLabel setTextAlignment:NSTextAlignmentRight];
        [textLabel setFont:[UIFont fontWithName:@"B Yekan+" size:15]];
        
        [textLabel sizeToFit];
        
        int size = textLabel.frame.size.height;
        
        return size + 78;
    }
    
    else
        
        return 50;
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

-(void)CustomizeView
{
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    
    barButtonItem.tintColor = [UIColor whiteColor];
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
}

@end
