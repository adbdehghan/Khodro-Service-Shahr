//
//  NewsTableViewCell.h
//  Khodro service shahr
//
//  Created by aDb on 2/12/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicsLikeControl.h"
#import "News.h"

@interface NewsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *containertView;
@property (weak, nonatomic) IBOutlet PicsLikeControl *likeContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *ImageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commnetCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *commnetButton;

+ (CGFloat)estimatedCellHeight;
@end
