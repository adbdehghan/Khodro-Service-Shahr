//
//  NewsTableViewCell.m
//  Khodro service shahr
//
//  Created by aDb on 2/12/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)estimatedCellHeight
{
    return 120.0f;
}

@end
