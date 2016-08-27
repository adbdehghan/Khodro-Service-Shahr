//
//  Notification.h
//  Khodro service shahr
//
//  Created by adb on 8/27/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"

@interface Notification : MBJSONModel
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,copy) NSString *time;
@end
