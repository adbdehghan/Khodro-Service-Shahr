//
//  AboutUSDetailViewController.h
//  Khodro service shahr
//
//  Created by aDb on 2/14/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUSDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIImageView *headerView;
@property (strong, nonatomic) IBOutlet UIView *statusBar;

@property (nonatomic) NSInteger menuID;

@end
