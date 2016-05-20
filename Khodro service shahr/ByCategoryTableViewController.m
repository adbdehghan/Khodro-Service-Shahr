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
#import "DetailViewController.h"
#import "ALCustomColoredAccessory.h"
#import "STCollapseTableView.h"
#import "MapViewController.h"

@interface ByCategoryTableViewController ()
@property (nonatomic, strong) NSMutableArray *results;
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSMutableArray *searchplaces;
@property (nonatomic, strong) NSMutableArray *placesCopy;
@end

@implementation ByCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
    [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
    
    self.places = [[NSMutableArray alloc]init];
    self.categories = [[NSMutableArray alloc]init];
    
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                
                MapCategory *category = [MapCategory modelFromJSONDictionary:item];
                
                [self.categories addObject:category];
                
                for (MapPlace *item in category.items) {
                    
                    [self.places addObject:item];
                    
                }
            }
            
            [self.tableView reloadData];
            
            
            self.placesCopy = [self.places mutableCopy];
            
            
            if (self.places.count > 0) {
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                
                
            }
            else
            {
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
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
    
    
    [self.getData SearchByCat:self.searchedString withCallback:callback];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table View
//- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
//{
//    return YES;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.categories.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([self tableView:tableView canCollapseSection:section])
//    {
//        if ([expandedSections containsIndex:section])
//        {
//            NSLog(@"Selected Section is %ld ",(long)((MapCategory*)[self.categories objectAtIndex:section]).items.count);
//        
            return ((MapCategory*)[self.categories objectAtIndex:section]).items.count;
//        }
//        return 1;
//    }
//    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // all other rows
    cell.textLabel.text = ((MapPlace*)[((MapCategory*)[self.categories objectAtIndex:indexPath.section]).items objectAtIndex:indexPath.row]).Title;
    cell.imageView.image = nil;
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [[cell textLabel] setTextAlignment:NSTextAlignmentRight];
    [[cell textLabel] setFont:[UIFont fontWithName:@"B Yekan+" size:17]];
    [[cell textLabel] setTextColor:[UIColor grayColor]];
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapPlace *place =((MapPlace*)[((MapCategory*)[self.categories objectAtIndex:indexPath.section]).items objectAtIndex:indexPath.row]);
    self.markerLocation = place;
    [self performSegueWithIdentifier:@"map" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 3, self.view.frame.size.width , 60);
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    
    UILabel *catName = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, self.view.frame.size.width-54 , 54)];
    
    catName.text = ((MapCategory*)[self.categories objectAtIndex:section]).CatName; // only top row showing
    [catName setTextAlignment:NSTextAlignmentRight];
    [catName setFont:[UIFont fontWithName:@"B Yekan+" size:17]];
    [catName setTextColor:[UIColor blackColor]];
    
    [view addSubview:catName];
    
    UIView *sepratorView = [[UIView alloc]initWithFrame:CGRectMake(20,59, [UIScreen mainScreen].bounds.size.width-28 , 1)];
    [sepratorView setBackgroundColor:[UIColor lightGrayColor]];
    sepratorView.alpha = .3f;
    [view addSubview:sepratorView];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-45, 10, 40, 40)];
    icon.image = [UIImage imageNamed:@"park"];
    
    [view addSubview:icon];
//    cell.imageView.image = [self getCategoryImage:@"park"];
    
    return view;
}


- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

-(UIImage*)getCategoryImage:(NSString*)name
{
    if ([name isEqualToString:@"police"]) {
        return [UIImage imageNamed:@"police"];
    }
    else if ([name isEqualToString:@"around"]) {
        return [UIImage imageNamed:@"around"];
    }
    else if ([name isEqualToString:@"building"]) {
        return [UIImage imageNamed:@"building"];
    }
    else if ([name isEqualToString:@"bus"]) {
        return [UIImage imageNamed:@"bus"];
    }
    else if ([name isEqualToString:@"carRe"]) {
        return [UIImage imageNamed:@"carRe"];
    }
    else if ([name isEqualToString:@"carwash"]) {
        return [UIImage imageNamed:@"carwash"];
    }
    else if ([name isEqualToString:@"cinema"]) {
        return [UIImage imageNamed:@"cinema"];
    }
    else if ([name isEqualToString:@"drug"]) {
        return [UIImage imageNamed:@"drug"];
    }
    else if ([name isEqualToString:@"gas"]) {
        return [UIImage imageNamed:@"gas"];
    }
    else if ([name isEqualToString:@"history"]) {
        return [UIImage imageNamed:@"history"];
    }
    else if ([name isEqualToString:@"park"]) {
        return [self image:[UIImage imageNamed:@"park"] scaledToSize:CGSizeMake(42, 42)];
    }
    else if ([name isEqualToString:@"mosque"]) {
        return [UIImage imageNamed:@"mosque"];
    }
    else if ([name isEqualToString:@"office"]) {
        return [UIImage imageNamed:@"office"];
    }
    else if ([name isEqualToString:@"train"]) {
        return [UIImage imageNamed:@"train"];
    }
    else if ([name isEqualToString:@"passport"]) {
     return [UIImage imageNamed:@"passport"];
    }
    else if ([name isEqualToString:@"shop"]) {
     return [UIImage imageNamed:@"shop"];
    }
    else if ([name isEqualToString:@"train"]) {
        return [UIImage imageNamed:@"train"];

    }

    return [self image:[UIImage imageNamed:@"marker.png"] scaledToSize:CGSizeMake(38, 38)];
}


- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *destination = [segue destinationViewController];
    destination.isSegue = YES;
    destination.markerLocation = self.markerLocation;
}



@end
