//
//  MapCategory.m
//  Khodro service shahr
//
//  Created by aDb on 1/30/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "MapCategory.h"
#import "MapPlace.h"

@implementation MapCategory
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"ID" : @"ID",
             @"Name" : @"Name",
             @"CatName" : @"CatName",
             @"ImageUrl" : @"ImageUrl",
             @"Comment" : @"Comment",
             @"data.mapcategory.Items" : @{@"class" : NSStringFromClass([MapPlace class]), @"relationship" : @"items", @"isArray" : @YES},
             };
}
@end
