//
//  Competition.h
//  Khodro service shahr
//
//  Created by aDb on 2/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"


@interface Competition : MBJSONModel
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *Title;
@property(nonatomic,copy) NSString *StartDate;
@property(nonatomic,copy) NSString *ExpireDate;
@property(nonatomic,copy) NSString *Comment;
@property(nonatomic,copy) NSArray  *medias;
@property(nonatomic,copy) NSArray  *Questions;


@end
