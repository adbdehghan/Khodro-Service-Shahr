//
//  CommentViewController.h
//  Khodro service shahr
//
//  Created by aDb on 2/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *newsID;
@property (nonatomic, strong) NSString *mediaID;
@end
