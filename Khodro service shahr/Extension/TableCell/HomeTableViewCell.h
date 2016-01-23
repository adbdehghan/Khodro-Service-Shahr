//
//  HomeTableViewCell.h
//  Khodro service shahr
//
//  Created by aDb on 12/26/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containertView;
@property (weak, nonatomic) IBOutlet UIView *likeContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commnetCountLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end
