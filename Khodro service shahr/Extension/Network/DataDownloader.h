//
//  DataDownloader.h
//  2x2
//
//  Created by aDb on 2/25/15.
//  Copyright (c) 2015 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDownloader : NSObject

typedef void (^RequestCompleteBlock) (BOOL wasSuccessful,NSMutableDictionary *recievedData);
typedef void (^ImageRequestCompleteBlock) (BOOL wasSuccessful,UIImage *image);

- (void)RequestMedia:(NSString *)params withCallback:(RequestCompleteBlock)callback;

- (void)GetMapCategories:(RequestCompleteBlock)callback;
- (void)GetCategoryLocations:(NSString *)params withCallback:(RequestCompleteBlock)callback;
- (void)GetEvents:(NSString *)param withCallback:(RequestCompleteBlock)callback;
- (void)GetEventsCats:(NSString *)param withCallback:(RequestCompleteBlock)callback;
- (void)GetEventByCat:(NSString *)param withCallback:(RequestCompleteBlock)callback;
- (void)GetEventByID:(NSString *)param withCallback:(RequestCompleteBlock)callback;
- (void)AddComment:(NSString *)phoneNumber Password:(NSString*)password eventID:(NSString*)eventId Comment:(NSString*)comment withCallback:(RequestCompleteBlock)callback;
- (void)LikeNews:(NSString *)phoneNumber Password:(NSString*)password eventID:(NSString*)eventId withCallback:(RequestCompleteBlock)callback;
- (void)LikeMedia:(NSString *)phoneNumber Password:(NSString*)password eventID:(NSString*)eventId withCallback:(RequestCompleteBlock)callback;
- (void)AddCommentMedia:(NSString *)phoneNumber Password:(NSString*)password eventID:(NSString*)eventId Comment:(NSString*)comment withCallback:(RequestCompleteBlock)callback;
- (void)GetAd:(NSString*)param  withCallback:(RequestCompleteBlock)callback;
- (void)GetMessages:(NSString *)phoneNumber Password:(NSString*)password withCallback:(RequestCompleteBlock)callback;
- (void)GetTopParticipates:(NSString *)competitionid withCallback:(RequestCompleteBlock)callback;
- (void)GetPolls:(NSString*)param  withCallback:(RequestCompleteBlock)callback;
- (void)RequestMediaByProfileID:(NSString *)params withCallback:(RequestCompleteBlock)callback;
- (void)GetPoll:(NSString*)pollId withCallback:(RequestCompleteBlock)callback;
- (void)Participate:(NSString *)phoneNumber Password:(NSString*)password CompetitonID:(NSString*)CompetitonID Answer:(NSString*)Answer withCallback:(RequestCompleteBlock)callback;
- (void)GetEventComments:(NSString *)eventID withCallback:(RequestCompleteBlock)callback;
- (void)GetMediaComments:(NSString *)mediaID withCallback:(RequestCompleteBlock)callback;
- (void)GetEventsByID:(NSString *)param withCallback:(RequestCompleteBlock)callback;
- (void)GetGpsData:(NSString*)cellphone password:(NSString*)password withCallback:(RequestCompleteBlock)callback;
- (void)SearchByCat:(NSString*)param  withCallback:(RequestCompleteBlock)callback;
- (void)SearchLocations:(NSString*)param  withCallback:(RequestCompleteBlock)callback;
- (void)SetGpsDevice:(NSString *)phoneNumber Password:(NSString*)password ime:(NSString*)ime simcard:(NSString*)simcard withCallback:(RequestCompleteBlock)callback;


- (void)GetProfilePicInfo:(NSString *)phoneNumber Password:(NSString*)password withCallback:(RequestCompleteBlock)callback;
- (void)SetSetiing:(NSString *)phoneNumber Password:(NSString*)password Name:(NSString*)name LastName:(NSString*)lastName Gender:(NSString*)gender city:(NSString*)city birthdayDay:(NSString*) birthdayDay birhtdayMonth:(NSString*)birhtdayMonth birhtdayYear:(NSString*)birhtdayYear withCallback:(RequestCompleteBlock)callback;

- (void)RequestPayroll:(NSString *)year Month:(NSString*)month DriverCode:(NSString*)driverCode hesabNo:(NSString*)hesabNo CodeMeli:(NSString*)codeMeli withCallback:(RequestCompleteBlock)callback;

- (void)GetSetting:(NSString *)phoneNumber Password:(NSString*)password withCallback:(RequestCompleteBlock)callback;
- (void)Invite:(NSString *)phoneNumber Password:(NSString*)password contactNumber:(NSString*)contactNumber withCallback:(RequestCompleteBlock)callback;

- (void)SignIn:(NSString*)username Password:(NSString*)password withCallback:(RequestCompleteBlock)callback;

- (void)SignUp:(NSString*)name Lastname:(NSString*)lastname MobileNumber:(NSString*)mobilenumber Username:(NSString*)username Password:(NSString*)password Email:(NSString*)email deviceID:(NSString*)deviceID devType:(NSString*)devType  withCallback:(RequestCompleteBlock)callback;

- (void)ResetPassword:(NSString *)Cellphone withCallback:(RequestCompleteBlock)callback;
- (void)GetNotification:(NSString *)pid withCallback:(RequestCompleteBlock)callback;
@end
