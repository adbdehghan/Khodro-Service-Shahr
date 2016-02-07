//
//  MapCategory.m
//  Khodro service shahr
//
//  Created by aDb on 1/30/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "MapCategory.h"

@implementation MapCategory
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"ID" : @"ID",
             @"Name" : @"Name",
             @"ImageUrl" : @"ImageUrl",
             @"Comment" : @"Comment",
             };
}
@end
