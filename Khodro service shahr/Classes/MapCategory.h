//
//  MapCategory.h
//  Khodro service shahr
//
//  Created by aDb on 1/30/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"

@interface MapCategory : MBJSONModel
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *Name;
@property(nonatomic,copy) NSString *ImageUrl;
@property(nonatomic,copy) NSString *Comment;
@end
