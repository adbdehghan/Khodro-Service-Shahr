//
//  Media.m
//  Khodro service shahr
//
//  Created by aDb on 1/30/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "Media.h"
#import "NewsMedia.h"

@implementation Media
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"ID" : @"ID",
             @"Title" : @"Title",
             @"Caption" : @"Caption",
             @"CreateTime" : @{@"isDate" : @YES, @"format" : @"yyyy-MM-dd'T'HH:mm:ss.SSS", @"property" : @"CreateTime"},
             @"Comment_Count" : @"CommentCount",
             @"Like_Count" : @"LikeCount",
             @"data.media.items" : @{@"class" : NSStringFromClass([NewsMedia class]), @"relationship" : @"items", @"isArray" : @YES},
             };
}
@end
