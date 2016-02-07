//
//  News.h
//  Khodro service shahr
//
//  Created by aDb on 2/2/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"

@interface News : MBJSONModel
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *Detail;
@property(nonatomic,copy) NSString *Title;
@property(nonatomic,copy) NSString *CreatTime;
@property(nonatomic,copy) NSString *CategoryName;
@property(nonatomic,copy) NSArray *Medias;
@property(nonatomic,copy) NSString *CommentCount;
@property(nonatomic,copy) NSString *LikeCount;
@property(nonatomic) BOOL *IsLiked;
@end
