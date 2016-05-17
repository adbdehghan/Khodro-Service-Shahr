//
//  CommentTableViewCell.m
//  Khodro service shahr
//
//  Created by aDb on 2/4/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell
@synthesize usernameLabel = _usernameLabel;
@synthesize commentLabel = _commentLabel;
@synthesize userImage = _userImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.frame.size.width -8, 30)];
        self.usernameLabel.textColor = [UIColor colorWithRed:70/255.f green:82/255.f blue:161/255.f alpha:1];
        self.usernameLabel.font = [UIFont fontWithName:@"B Yekan+" size:16];
        self.usernameLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:self.usernameLabel];
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 34, self.frame.size.width-8 , 30)];
        self.commentLabel.textColor = [UIColor blackColor];
        self.commentLabel.font = [UIFont fontWithName:@"B Yekan+" size:13];
        self.commentLabel.textAlignment = NSTextAlignmentRight;

        [self addSubview:self.commentLabel];
        
        
        self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 10, 40, 40)];
        self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2;

        
        [self addSubview:self.userImage];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
