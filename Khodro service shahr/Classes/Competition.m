//
//  Competition.m
//  Khodro service shahr
//
//  Created by aDb on 2/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "Competition.h"
#import "NewsMedia.h"

@implementation Competition
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"ID" : @"ID",
             @"Title" : @"Title",
             @"StartDate" : @"StartDate",
             @"ExpireDate" : @"ExpireDate",
             @"Question" : @"Question",
             @"Option1" : @"Option1",
             @"Option2" : @"Option2",
             @"Option3" : @"Option3",
             @"Option4" : @"Option4",
             @"Comment" : @"Comment",
             @"data.Competition.medias" : @{@"class" : NSStringFromClass([NewsMedia class]), @"relationship" : @"medias", @"isArray" : @YES},
             };
}
@end
