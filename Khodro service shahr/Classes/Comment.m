//
//  Comment.m
//  Khodro service shahr
//
//  Created by aDb on 2/4/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "Comment.h"

@implementation Comment
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"ID" : @"ID",
             @"user_id" : @"userID",
             @"user_image" : @"userImage",
             @"CommentTime" : @{@"isDate" : @YES, @"format" : @"yyyy-MM-dd'T'HH:mm:ss.SSS", @"property" : @"CommentTime"},
             @"Comment" : @"Comment",
             };
}
@end
