//
//  User.h
//  Hyper Me
//
//  Created by aDb on 10/17/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"

@interface User : MBJSONModel
@property (nonatomic,strong) NSString *itemId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *lastname;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *PicThumb;

@end
