//
//  Competition.m
//  Khodro service shahr
//
//  Created by aDb on 2/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "Competition.h"
#import "NewsMedia.h"
#import "CompetitionQuestion.h"

@implementation Competition
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"ID" : @"ID",
             @"Title" : @"Title",
             @"StartDate" : @"StartDate",
             @"ExpireDate" : @"ExpireDate",
             @"Comment" : @"Comment",
             @"data.Competition.medias" : @{@"class" : NSStringFromClass([NewsMedia class]), @"relationship" : @"medias", @"isArray" : @YES},
             @"data.Competition.questions" : @{@"class" : NSStringFromClass([CompetitionQuestion class]), @"relationship" : @"questions", @"isArray" : @YES},
             };
}
@end
