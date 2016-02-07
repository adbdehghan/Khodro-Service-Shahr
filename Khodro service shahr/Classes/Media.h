//
//  Media.h
//  Khodro service shahr
//
//  Created by aDb on 1/30/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"

@interface Media : MBJSONModel
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSString *Caption;
@property(nonatomic,strong) NSString *CreateTime;
@property(nonatomic,strong) NSString *Comment;
@property(nonatomic,strong) NSArray *items;
@property(nonatomic,strong) NSString *CommentCount;
@property(nonatomic,strong) NSString *LikeCount;

@end
