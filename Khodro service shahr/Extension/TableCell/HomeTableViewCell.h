//
//  HomeTableViewCell.h
//  Khodro service shahr
//
//  Created by aDb on 12/26/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicsLikeControl.h"

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containertView;
@property (weak, nonatomic) IBOutlet PicsLikeControl *likeContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *ImageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commnetCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *commnetButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end
