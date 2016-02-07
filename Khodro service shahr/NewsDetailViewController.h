//
//  NewsDetailViewController.h
//  Khodro service shahr
//
//  Created by aDb on 2/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsDetailViewController : UIViewController
@property(nonatomic,strong)News *news;
@property(nonatomic,strong)IBOutlet UIView *containerView;
@end
