//
//  MenuViewController.h
//  Khodro service shahr
//
//  Created by aDb on 1/18/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *sympolsImage;
@property (strong, nonatomic) IBOutlet UIImageView *firstImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondImage;
@property(nonatomic,strong)NSNumber *MenuSelectedIndex;
@end
