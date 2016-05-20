//
//  MapPlace.h
//  Khodro service shahr
//
//  Created by aDb on 1/31/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"

@interface MapPlace : MBJSONModel
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *Title;
@property(nonatomic,copy) NSString *Lat;
@property(nonatomic,copy) NSString *Lng;
@property(nonatomic,copy) NSString *Manager;
@property(nonatomic,copy) NSString *Address;
@property(nonatomic,copy) NSString *Area;
@property(nonatomic,copy) NSString *CategoryID;
@property(nonatomic,copy) NSString *Email;
@property(nonatomic,copy) NSString *Fax;
@property(nonatomic,copy) NSString *Mobile;
@property(nonatomic,strong) NSNumber *distance;
@end
