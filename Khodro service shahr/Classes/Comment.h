//
//  Comment.h
//  Khodro service shahr
//
//  Created by aDb on 2/4/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"

@interface Comment : MBJSONModel
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *userID;
@property(nonatomic,copy) NSString *userImage;
@property(nonatomic,copy) NSString *CommentTime;
@property(nonatomic,copy) NSString *Comment;
@end
