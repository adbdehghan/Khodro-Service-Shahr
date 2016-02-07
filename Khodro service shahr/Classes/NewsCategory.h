//
//  NewsCategory.h
//  Khodro service shahr
//
//  Created by aDb on 2/2/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"

@interface NewsCategory : MBJSONModel
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *Name;
@end
