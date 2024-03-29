//
//  BROptionItem.h
//  BROptionsButtonDemo
//
//  Created by Basheer Malaa on 3/10/14.
//  Copyright (c) 2014 Basheer Malaa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultButtonHeight  50


@interface BROptionItem : UIButton
@property (nonatomic, readonly) NSInteger index;

@property (nonatomic, strong) UIAttachmentBehavior *attachment;
- (instancetype)initWithIndex:(NSInteger)index;
@end
