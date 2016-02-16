//
//  CompetitionQuestion.m
//  Khodro service shahr
//
//  Created by aDb on 2/14/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "CompetitionQuestion.h"

@implementation CompetitionQuestion
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"$id" : @"ID",
             @"question" : @"Question",
             @"option1" : @"Option1",
             @"option2" : @"Option2",
             @"option3" : @"Option3",
             @"option4" : @"Option4",
             };
}
@end
