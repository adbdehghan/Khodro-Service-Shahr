//
//  Notification.m
//  Khodro service shahr
//
//  Created by adb on 8/27/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "Notification.h"

@implementation Notification
+ (NSDictionary *)JSONKeyTranslationDictionary
{
    return @{
             @"ID" : @"ID",
             @"Type" : @"type",
             @"Time" : @"time",
             @"Title" : @"title",
             @"Message" : @"message",
             };
}
@end
