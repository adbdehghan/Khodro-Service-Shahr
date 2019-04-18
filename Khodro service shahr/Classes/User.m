//
//  User.m
//  Hyper Me
//
//  Created by aDb on 10/17/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import "User.h"

@implementation User
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"ID" : @"itemId",
             @"Firstname" : @"name",
             @"Lastname" : @"lastname",
             @"ShowName" : @"username",
             @"Pic" : @"pic",
             @"PicThumb" : @"PicThumb",
             @"Cellphone" : @"mobile",
             };
}
@end
