//
//  DeviceRegisterer.m
//  2x2
//
//  Created by aDb on 4/25/15.
//  Copyright (c) 2015 aDb. All rights reserved.
//

#import "DeviceRegisterer.h"
#import "AFNetworking.h"
#import "Settings.h"
#import "DBManager.h"
#define URLaddress "http://admin.safirangps.ir/api/mobile/SetKeyIos"

@implementation DeviceRegisterer

- (void)registerDeviceWithToken:(NSString *)token {

        NSDictionary *parameters = @{@"key": token};
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        NSString *URLString = @URLaddress;
        
        
        [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Success %@", responseObject);
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Failure %@, %@", error, operation.responseString);
        }];
    
}

@end
