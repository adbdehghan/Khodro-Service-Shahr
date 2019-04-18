//
//  AIMBalloon.m
//  AIMBalloon
//
//  Created by Marek Kotewicz on 11.09.2013.
//  Copyright (c) 2013 AllInMobile. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//based on: https://gist.github.com/Dimillian/5868026/raw/1023ff9466e09f73af4944273f3a2cbc4e65bf2a/gistfile1.txt

#import "AIMBalloon.h"
#import "UIBezierPath+SmoothPath.h"
#import "UIImage+ImageEffects.h"
#import "UIView+Genie.h"

#if !__has_feature(objc_arc)
#error AIMBalloon must be built with ARC.
// You can turn on ARC for only AIMBalloon files by adding -fobjc-arc to the build phase for each of its files.
#endif

#ifndef __IPHONE_7_0
#error "AIMBalloon uses features only available in iOS SDK 7.0 and later."
#endif

@interface AIMBalloon (){
    UIDynamicAnimator       *animator;
    UIButton                  *balloon;
    UIAttachmentBehavior    *touchAttachmentBehavior;
    UIView *mainView;
    UIAttachmentBehavior *attachmentBehavior;
    UIGravityBehavior *gravityBeahvior;
}

@end

@implementation AIMBalloon


- (void)Create:(UIView*)view linkedToView:(UIView*)linkedView image:(UIImage*)image size:(int)size tag:(int)tag{

    mainView =view;
        
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:view];
    UIView *previousLink        = linkedView;
    
    // setup variables
    NSInteger numberOfLinks     = size;
    CGFloat spaceBetweenLinks   = 0.f;
    CGSize linkSize             = CGSizeMake(10, 10);
    
    // setup line parameters
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.strokeEnd = 1.0f;
    
    [view.layer addSublayer:shapeLayer];
    
    NSMutableArray *linksArray      = [[NSMutableArray alloc] initWithCapacity:numberOfLinks];
    NSMutableArray *points          = [[NSMutableArray alloc] initWithCapacity:numberOfLinks + 2];
    
    [points addObject:[NSValue valueWithCGPoint:previousLink.center]];
    
    CGFloat currentY = linkedView.frame.origin.y + linkedView.bounds.size.height;
    
    // create links
    for (int i = 0; i < numberOfLinks; i++) {
        UIView *link = [[UIView alloc] initWithFrame:CGRectMake(linkedView.center.x, currentY + spaceBetweenLinks, linkSize.width, linkSize.height)];
        link.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.0];  // debug value
        link.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        
        [view addSubview:link];
        
        
        UIAttachmentBehavior *attachmentBehavior = nil;
        if (i == 0) {
            attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:link
                                                           offsetFromCenter:UIOffsetMake(0, 0)
                                                           attachedToAnchor:linkedView.center];
            
        } else {
            attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:link
                                                           offsetFromCenter:UIOffsetMake(0, -1)
                                                             attachedToItem:previousLink
                                                           offsetFromCenter:UIOffsetMake(0, 1)];
        }
        
        [points addObject:[NSValue valueWithCGPoint:link.center]];
        
        [attachmentBehavior setAction:^{
            points[i+1] = [NSValue valueWithCGPoint:link.center];
            shapeLayer.path = [[UIBezierPath smoothPathFromArray:points] CGPath];
        }];
        
        [animator addBehavior:attachmentBehavior];
        
        currentY += linkSize.height + spaceBetweenLinks;
        [linksArray addObject:link];
        previousLink = link;
    }
    
    
    // create ballon
    CGSize ballSize = CGSizeMake(65, 65);
    balloon =[UIButton buttonWithType:UIButtonTypeCustom];// [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - ballSize.width/2, currentY + spaceBetweenLinks, ballSize.width, ballSize.height)];
    UIImage *buttonImage = image;
    
    balloon.frame = CGRectMake(linkedView.center.x, currentY + spaceBetweenLinks, ballSize.width, ballSize.height);
    balloon.tag = tag;
    [balloon addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [balloon setImage:buttonImage forState:UIControlStateNormal];
    balloon.backgroundColor = [UIColor clearColor];
    balloon.layer.cornerRadius = ballSize.width/2;
    
    //        balloon.center = CGPointMake(balloon.center.x, balloon.center.y-30);
    
    [view addSubview:balloon];
    
    
    
    
    //        // Connect balloon to the chain
    attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:previousLink
                                                                           attachedToItem:balloon];
    
    attachmentBehavior.attachmentRange = UIFloatRangeZero;
    attachmentBehavior.frictionTorque = 15.f;

    
    [animator addBehavior:attachmentBehavior];
    
    [points addObject:[NSValue valueWithCGPoint:balloon.center]];
    
    
    
    
    [attachmentBehavior setAction:^{
        points[numberOfLinks+1] = [NSValue valueWithCGPoint:balloon.center];
        shapeLayer.path = [[UIBezierPath smoothPathFromArray:points] CGPath];
    }];
    
    // Apply gravity and collision
    [linksArray addObject:balloon];
    
    gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:linksArray];
    [gravityBeahvior setGravityDirection:CGVectorMake(0, 1)];
    [gravityBeahvior setMagnitude:0.5f];
    
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:linksArray];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [animator addBehavior:gravityBeahvior];
    [animator addBehavior:collisionBehavior];

}

-(void)buttonTouched:(id)Sender
{
    if (((UIButton*)Sender).tag != 5) {
    [animator removeBehavior:attachmentBehavior];
    [gravityBeahvior setMagnitude:0.f];
    [animator removeBehavior:gravityBeahvior];
    [self genieToRect:CGRectMake(mainView.center.x-24, mainView.frame.size.height-98, 50, 50) edge:BCRectEdgeTop];
    }
    [self performSelector:@selector(cutTheRope:) withObject:Sender afterDelay:.45f];
    
}

-(void)cutTheRope:(id)Sender
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          Sender
                                                     forKey:@"button"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menu"
                                                        object:nil
                                                      userInfo:dict];

}

- (void) genieToRect: (CGRect)rect edge: (BCRectEdge) edge
{
    NSTimeInterval duration = .69f;
    
    CGRect endRect = CGRectInset(rect, 5.0, 5.0);
    
    [balloon genieInTransitionWithDuration:duration destinationRect:endRect destinationEdge:edge  completion:^{
        
        
    }];
    
}

//// Let the user pull the balloon around
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    touchAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:balloon
//                                                        attachedToAnchor:balloon.center];
//    [animator addBehavior:touchAttachmentBehavior];
//    [touchAttachmentBehavior setFrequency:1.0];
//    [touchAttachmentBehavior setDamping:0.1];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    touchAttachmentBehavior.anchorPoint = [touch locationInView:mainView];;
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    [animator removeBehavior:touchAttachmentBehavior];
//    touchAttachmentBehavior = nil;
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    [animator removeBehavior:touchAttachmentBehavior];
//    touchAttachmentBehavior = nil;
//}



@end
