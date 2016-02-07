//
//  NewsMedia.h
//  Khodro service shahr
//
//  Created by aDb on 2/2/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBJSONModel.h"

@interface NewsMedia : MBJSONModel
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *ThumbUrl;
@property(nonatomic,copy) NSString *MIMEType;
@property(nonatomic,copy) NSString *Url;
@end
