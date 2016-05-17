//
//  NewsMedia.m
//  Khodro service shahr
//
//  Created by aDb on 2/2/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "NewsMedia.h"

@implementation NewsMedia
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"$id" : @"ID",
             @"ThumbUrl" : @"ThumbUrl",
             @"MIMEType" : @"MIMEType",
              @"Url" : @"Url",
             };
}
@end
