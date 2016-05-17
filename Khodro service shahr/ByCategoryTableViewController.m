//
//  ByCategoryTableViewController.m
//  Khodro service shahr
//
//  Created by adb on 5/11/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "ByCategoryTableViewController.h"
#import "DataDownloader.h"
#import "MapPlace.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIWindow+YzdHUD.h"
#import "LGFilterView.h"
#import "MapCategory.h"
#import "JTProgressHUD.h"


@interface ByCategoryTableViewController ()
@property (nonatomic, strong) NSMutableArray *results;
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSMutableArray *searchplaces;
@property (nonatomic, strong) NSMutableArray *placesCopy;
@end

@implementation ByCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.places = [[NSMutableArray alloc]init];
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                MapPlace *place = [MapPlace modelFromJSONDictionary:item];
                [self.places addObject:place];
                
                
                
            }
            
            
            self.placesCopy = [self.places mutableCopy];
            
            
            if (self.places.count > 0) {
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                
                
            }
            else
            {
                //                    self.actualRequest2 = [[FTGooglePlacesAPITextSearchRequest alloc] initWithQuery:searchBar.searchField.text];
                //                    [self startSearching];
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                
                //                    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
                //                    acController.delegate = self;
                //                    [self presentViewController:acController animated:YES completion:nil];
                
                //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                //                                                                    message:@"مکان مورد نظر یافت نشد"
                //                                                                   delegate:self
                //                                                          cancelButtonTitle:@"تایید"
                //                                                          otherButtonTitles:nil];
                //                    [alert show];
            }
            
            
            
            
        }
        
        else
        {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    
    [self.getData SearchLocations:self.searchedString withCallback:callback];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}


@end
