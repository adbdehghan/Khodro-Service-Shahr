//
//  News.m
//  Khodro service shahr
//
//  Created by aDb on 2/2/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "News.h"
#import "NewsMedia.h"

@implementation News
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"ID" : @"ID",
             @"Title" : @"Title",
             @"Detail" : @"Detail",
             @"CreatTime" : @{@"isDate" : @YES, @"format" : @"yyyy-MM-dd'T'HH:mm:ss.SSS", @"property" : @"CreatTime"},
             @"Category_Name" : @"CategoryName",
             @"Comment_Count" : @"CommentCount",
             @"Like_Count" : @"LikeCount",
             @"isLiked":@"IsLiked",
             @"data.news.Medias" : @{@"class" : NSStringFromClass([NewsMedia class]), @"relationship" : @"Medias", @"isArray" : @YES},
             };
}
@end
