//
//  AppDelegate.h
//  Khodro service shahr
//
//  Created by aDb on 12/6/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain)User *user;
@property (nonatomic)BOOL adShown;

@end

