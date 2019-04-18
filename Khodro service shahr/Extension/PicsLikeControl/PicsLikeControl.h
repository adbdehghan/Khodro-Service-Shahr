//
//  PicLikeControl.h
//  PicsLikeControl
//
//  Created by Tu You on 13-12-27.
//  Copyright (c) 2013年 Tu You. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicsLikeControlDelegate <NSObject>

- (void)controlTappedAtIndex:(int)index Sender:(id)sender;

@end

@interface PicsLikeControl : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <PicsLikeControlDelegate> delegate;

/**
 *  initialization
 *
 *  @param frame         frame of the view
 *  @param image         default image for the button above
 *  @param behindImage   defautt image for the button below
 *
 *  @return PicsLikeControl
 */

- (id)initWithFrame:(CGRect)frame
         frontImage:(UIImage *)image
        behindImage:(UIImage *)behindImage;

/**
 *  initialization
 *
 *  @param frame         frame of the view
 *  @param multiImages   a series of images for the series of button
 *
 *  @return PicsLikeControl
 */
- (id)initWithFrame:(CGRect)frame
        multiImages:(NSArray *)multiImages;

- (void)SetmultiImages:(NSArray *)multiImages;

-(void)ManualTap;
-(void)Dislike;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
