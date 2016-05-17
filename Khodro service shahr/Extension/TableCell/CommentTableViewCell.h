//
//  CommentTableViewCell.h
//  Khodro service shahr
//
//  Created by aDb on 2/4/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *userImage;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *commentLabel;
@end
