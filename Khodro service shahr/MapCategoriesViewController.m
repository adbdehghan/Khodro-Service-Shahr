//
//  MapCategoriesViewController.m
//  Khodro service shahr
//
//  Created by aDb on 1/30/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "MapCategoriesViewController.h"
#import "JBParallaxCell.h"
#import "DataDownloader.h"
#import "MapCategory.h"
#import "MBJSONModel.h"
#import "MapViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "INSSearchBar.h"
#import "MapPlace.h"
#import "UIWindow+YzdHUD.h"

static NSString *const ServerURL = @"http://khodroservice.kara.systems";
@interface MapCategoriesViewController () <UIScrollViewDelegate,INSSearchBarDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, strong) NSMutableArray *tableItems;
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, strong)   NSString *categoryID;
@property (nonatomic, strong)   NSString *categoryName;
@property (nonatomic, strong)   NSString *categoryURL;
@property (nonatomic, strong) INSSearchBar *searchBarWithDelegate;
@property (nonatomic, strong) NSMutableArray *places;
@end

@implementation MapCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreateMenuButton];
    // Load the items in the table
    [self CreateNavigationBarButtons];
    
    self.searchBarWithDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake(40, 0, CGRectGetWidth(self.view.bounds) - 40.0, 34.0)];
    self.searchBarWithDelegate.delegate = self;
    self.navigationItem.titleView = self.searchBarWithDelegate;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [activityIndicator startAnimating];
    
    self.tableItems = [[NSMutableArray alloc]init];
        self.places = [[NSMutableArray alloc]init];
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
        

            for (NSDictionary *item in (NSMutableArray*)data) {
                
                MapCategory *category = [MapCategory modelFromJSONDictionary:item];
                [self.tableItems addObject:category];
                [self.tableView reloadData];
                
            }
            
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

    
       [self.getData GetMapCategories:callback];
    

}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
    [self.places removeAllObjects];
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            

            for (NSDictionary *item in (NSMutableArray*)data) {
                
                MapPlace *place = [MapPlace modelFromJSONDictionary:item];
                [self.places addObject:place];
                
                
                
                
            }
            if (self.places.count > 0) {
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                [self performSegueWithIdentifier:@"places" sender:self];
                
            }
            else
            {
                [self.view.window showHUDWithText:@"مکان مورد نظر یافت نشد" Type:ShowDismiss Enabled:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                                message:@"مکان مورد نظر یافت نشد"
                                                               delegate:self
                                                      cancelButtonTitle:@"خب"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            


            
        }
        
        else
        {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"خب"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    
    [self.getData SearchLocations:searchBar.searchField.text  withCallback:callback];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.places removeAllObjects];
    [self scrollViewDidScroll:nil];
}

-(void)CreateMenuButton
{
    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingImage = [[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuButton setImage:settingImage forState:UIControlStateNormal];
    
    menuButton.tintColor = [UIColor whiteColor];
    [menuButton addTarget:self action:@selector(GoToMenu)forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 24, 24)];
    
    
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = settingBarButton;
    
    
}

-(void)GoToMenu
{
    
    [self performSegueWithIdentifier:@"first" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"parallaxCell";
    JBParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",((MapCategory*)self.tableItems[indexPath.row]).Name];
    cell.subtitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"This is a parallex cell %d",),indexPath.row];
    
//        NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,((MapCategory*)self.tableItems[indexPath.row]).ImageUrl];
//    
//     [cell.parallaxImage setImageWithURL:[NSURL URLWithString:fullURL]
//                           placeholderImage:[UIImage imageNamed:@"cover.jpg"] options:SDWebImageRefreshCached usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)UIActivityIndicatorViewStyleGray];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.categoryID = ((MapCategory*)self.tableItems[indexPath.row]).ID;
    self.categoryName = ((MapCategory*)self.tableItems[indexPath.row]).Name;
    self.categoryURL = ((MapCategory*)self.tableItems[indexPath.row]).ImageUrl;
    [self performSegueWithIdentifier:@"places" sender:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get visible cells on table view.
    NSArray *visibleCells = [self.tableView visibleCells];
    
    for (JBParallaxCell *cell in visibleCells) {
        [cell cellOnTableView:self.tableView didScrollOnView:self.view];
    }
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}
- (void)CreateNavigationBarButtons {
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"places"]) {
        MapViewController *destination = [segue destinationViewController];
        destination.categoryID = self.categoryID;
        destination.categoryName = self.categoryName;
        destination.categoryURL = self.categoryURL;
        destination.searchplaces = self.places;
    }

}


@end
