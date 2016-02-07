//
//  MapPlace.m
//  Khodro service shahr
//
//  Created by aDb on 1/31/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "MapPlace.h"

@implementation MapPlace
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"ID" : @"ID",
             @"Title" : @"Title",
             @"Lat" : @"Lat",
             @"Lng" : @"Lng",
             @"Manager" : @"Manager",
             @"Address" : @"Address",
             @"Area" : @"Area",
             @"CategoryID" : @"CategoryID",
             @"Email" : @"Email",
             @"Fax" : @"Fax",
             @"Mobile" : @"Mobile",
             };
}
@end
