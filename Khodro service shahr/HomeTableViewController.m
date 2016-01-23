//
//  HomeTableViewController.m
//  Khodro service shahr
//
//  Created by aDb on 12/26/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeTableViewCell.h"
#import "JDFPeekabooCoordinator.h"

static NSString *const cellIdentifier = @"identifier";

@interface HomeTableViewController ()
@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIColor *blueColour = [UIColor colorWithRed:44.0f/255.0f green:62.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
    
//    self.navigationController.toolbarHidden = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
    self.scrollCoordinator.scrollView = self.tableView;
    self.scrollCoordinator.topView = self.navigationController.navigationBar;
    self.scrollCoordinator.topViewMinimisedHeight = 20.0f;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:250/255.f alpha:1];

//    self.navigationItem.title = @"Peekaboo";
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
  //  [self.tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    
}

- (void)controlTappedAtIndex:(int)index Sender:(id)sender
{
    NSLog(@"index at %d tapped", index);
    NSLog(@"tag: %ld tapped", (long)((PicsLikeControl*)(sender)).tag);

    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    
    HomeTableViewCell *cell=[self.tableView cellForRowAtIndexPath:hitIndex];
    
    NSInteger likeCount = [cell.likeCountLabel.text integerValue];
    
    if (index == 0)
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld",likeCount + 1];
    else
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld",likeCount - 1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 460;
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    cell.backgroundColor =[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([[cell.likeContainerView subviews] count]==0) {
            UIImage *image0 = [UIImage imageNamed:@"nonlike"];
            UIImage *image1 = [UIImage imageNamed:@"like"];
            NSArray *images = @[image0, image1];
            
            PicsLikeControl *picControl = [[PicsLikeControl alloc] initWithFrame:CGRectMake(5, 0, 30, 30) multiImages:images];
            picControl.tag = indexPath.row;
            
            picControl.delegate = self;
            
            [cell.likeContainerView addSubview:picControl];
        }
    
    return cell;
}

@end
