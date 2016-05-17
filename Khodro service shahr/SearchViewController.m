//
//  SearchViewController.m
//  Khodro service shahr
//
//  Created by adb on 5/8/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "SearchViewController.h"
#import "ByDistanceTableViewController.h"
#import "ByCategoryTableViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"نتیجه جستوجو";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    // Get the previous view controller
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    
    
    self.segmentedPager.parallaxHeader.view = nil;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.segmentedPager.parallaxHeader.height = 60;
    self.segmentedPager.parallaxHeader.minimumHeight = 60;
    
    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:74/255.f green:144/255.f blue:226/255.f alpha:1.f]};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.type = HMSegmentedControlTypeText;
    
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:49.f/255.f green:168.f/255.f blue:16.f/255.f alpha:1];
    
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(0, 0, 1, 0);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(MXPageSegue *)segue sender:(id)sender {

    
    
    switch (segue.pageIndex) {
        case 0:
        {
            
            ByCategoryTableViewController *categoryViewController = segue.destinationViewController;
            categoryViewController.searchedString = self.searchedString;
        }
            break;
        case 1:
        {
            
            ByDistanceTableViewController *distanceViewController = segue.destinationViewController;
            distanceViewController.searchedString = self.searchedString;
            distanceViewController.myLocation = self.myLocation;
        }
            break;
        default:
            break;
    }
    
}

#pragma mark <MXSegmentedPagerControllerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 2;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return @[@"دسته بندی", @"فاصله"][index];
}

//- (UIImage*) segmentedPager:(MXSegmentedPager*)segmentedPager imageForSectionAtIndex:(NSInteger)index
//{
//    return @[[UIImage imageNamed:@"scoreListD@2x"],[UIImage imageNamed:@"transactionD@2x"]][index];
//}
//
//- (UIImage*) segmentedPager:(MXSegmentedPager*)segmentedPager selectedImageForSectionAtIndex:(NSInteger)index{
//    return @[[UIImage imageNamed:@"scoreList@2x"],[UIImage imageNamed:@"transaction@2x"]][index];
//    
//}

- (NSAttributedString*) segmentedPager:(MXSegmentedPager*)segmentedPager attributedTitleForSectionAtIndex:(NSInteger)index
{
    UIFont *font = [UIFont fontWithName:@"B Yekan+" size:14.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];


    
    switch (index) {
        case 0:
        {
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"دسته بندی" attributes:attrsDictionary];
            return attrString;
        }
            break;
        case 1:
        {
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"فاصله" attributes:attrsDictionary];
            return attrString;
        }
            break;
        default:
            break;
    }
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"دسته بندی" attributes:attrsDictionary];
    return attrString;
    
    
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager segueIdentifierForPageAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"category";
            break;
        case 1:
            return @"distance";
            break;
        default:
            break;
    }
    return @"category";
}



@end
