//
//  CompetitionQuestion.h
//  Khodro service shahr
//
//  Created by aDb on 2/14/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"

@interface CompetitionQuestion : MBJSONModel
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *Question;
@property(nonatomic,copy) NSString *Option1;
@property(nonatomic,copy) NSString *Option2;
@property(nonatomic,copy) NSString *Option3;
@property(nonatomic,copy) NSString *Option4;
@end
