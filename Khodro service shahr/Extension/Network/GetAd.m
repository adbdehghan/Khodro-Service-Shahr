//
//  GetAd.m
//  Khodro service shahr
//
//  Created by aDb on 2/15/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "GetAd.h"
#import "AFNetworking.h"
#define URLaddress "http://khodroservice.kara.systems/api/mobile/GetAd"

@implementation GetAd
- (void)CheckAd{
    

    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSString *URLString = @URLaddress;
    
    
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success %@", responseObject);
        if (responseObject != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AD"
                                                                object:nil
                                                              userInfo:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failure %@, %@", error, operation.responseString);
    }];
    
}
@end
