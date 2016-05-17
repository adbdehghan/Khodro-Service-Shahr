//
//  ByDistanceTableViewController.m
//  Khodro service shahr
//
//  Created by adb on 5/11/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "ByDistanceTableViewController.h"
#import "DataDownloader.h"
#import "MapPlace.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIWindow+YzdHUD.h"
#import "LGFilterView.h"
#import "MapCategory.h"
#import "JTProgressHUD.h"
#import <MapKit/MapKit.h>

@interface ByDistanceTableViewController ()
@property (nonatomic, strong) NSMutableArray *results;
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSMutableArray *searchplaces;
@property (nonatomic, strong) NSMutableArray *placesCopy;
@end

@implementation ByDistanceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.places = [[NSMutableArray alloc]init];
    self.placesCopy=[[NSMutableArray alloc]init];
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                MapPlace *place = [MapPlace modelFromJSONDictionary:item];
                [self.places addObject:place];
                
                
                
            }
            
            
            self.placesCopy = [self.places mutableCopy];
            
            for (MapPlace *place in self.placesCopy) {
                
                CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[place.Lat doubleValue] longitude:[place.Lng doubleValue]];
                
                
                CLLocationDistance distance = [LocationAtual distanceFromLocation:self.myLocation];
                
                NSNumber* num = [NSNumber numberWithFloat:distance];
                
                
                
                //  place.distance = [NSNumber numberWithFloat: [self directMetersFromCoordinate:self.myLocation.coordinate toCoordinate:CLLocationCoordinate2DMake([place.Lat doubleValue], [place.Lng doubleValue])]];
                place.distance = num;
                
                
                //   self.places = self.placesCopy;
                
                
            }
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
            
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
            [self.placesCopy sortUsingDescriptors:@[sortDescriptor]];
            self.places = self.placesCopy;

            
            
            if (self.places.count > 0) {
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                
                [self.tableView reloadData];
                
                
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
    
    
    [self.getData SearchLocations:[self.searchedString stringByReplacingOccurrencesOfString:@"ك" withString:@"ک"] withCallback:callback];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.places count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    MapPlace *mapPlace =(MapPlace*)[self.places objectAtIndex:indexPath.row];
    
    if (mapPlace != nil) {
        [[cell textLabel] setText:((MapPlace*)[self.places objectAtIndex:indexPath.row]).Title];
        [[cell textLabel] setTextAlignment:NSTextAlignmentRight];
        [[cell textLabel] setFont:[UIFont fontWithName:@"B Yekan+" size:17]];
        [[cell textLabel] setTextColor:[UIColor blackColor]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
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
