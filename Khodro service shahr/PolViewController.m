//
//  PolViewController.m
//  Khodro service shahr
//
//  Created by aDb on 1/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "PolViewController.h"
#import "GWQuestionnaire.h"
#import "Competition.h"
#import "DataDownloader.h"
#import "LCBannerView.h"
#import "NewsMedia.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "CompetitionQuestion.h"

#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
static NSString *const ServerURL = @"http://khodroservice.kara.systems";
static NSString *const ServerURL2 = @"http://khodroservice.kara.systems/api/mobile/ParticipationPost";
@interface PolViewController ()<LCBannerViewDelegate>
{
    GWQuestionnaire *surveyController;
    GWQuestionnaireItem *questionItem;
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray *pollAnswers;
    NSMutableArray *pollList;
    
}
@property (strong, nonatomic) DataDownloader *getData;

@property (strong, nonatomic) NSString *exAnswer;
@property (strong, nonatomic) NSString *answer;
@property (nonatomic) int offset;
@property (nonatomic,strong)User *user;

@end

@implementation PolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.user = app.user;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [activityIndicator startAnimating];
    

    
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.competitionTitle;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    
    barButtonItem.tintColor = [UIColor whiteColor];
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    
    
    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setTitle:@"ثبت"  forState:UIControlStateNormal];
    [menuButton.titleLabel setFont:[UIFont fontWithName:@"B Yekan+" size:19]];
    menuButton.titleLabel.textColor = [UIColor orangeColor];
    menuButton.tintColor = [UIColor orangeColor];
    [menuButton addTarget:self action:@selector(getAnswersPressed:)forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 35, 24)];
    
    
    UIBarButtonItem *signupButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    signupButton.tintColor = [UIColor orangeColor];
    
    [self.navigationItem setRightBarButtonItem:signupButton];
    
    
    self.offset = 60;
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
            [activityIndicator stopAnimating];
            
            
            Competition *competition = [Competition modelFromJSONDictionary:(NSDictionary*)data];
            
            NSMutableArray *URLs = [[NSMutableArray alloc]init];
            
            for (NewsMedia *item in competition.medias) {
                if ([item.MIMEType isEqualToString:@"image"]) {
                    NSString *fullURL = [NSString stringWithFormat:@"%@%@",ServerURL,item.Url];
                    [URLs addObject:fullURL];
                }
            }
            int time = 4;
            
            if (URLs.count == 1)
                time = 0;
            

            if (URLs.count > 0) {
                
                
                UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.frame), 220)];
                
                [headerView addSubview:({
                    
                    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 220)
                                                                        delegate:self
                                                                       imageURLs:URLs
                                                                placeholderImage:nil
                                                                   timerInterval:time
                                                   currentPageIndicatorTintColor:[UIColor greenColor]
                                                          pageIndicatorTintColor:[UIColor whiteColor]];
                    bannerView;
                })];
                
                
                
                [self.view addSubview:headerView];
                
                self.offset = 280;
            }
            
            
            
            
            NSMutableArray *questions = [NSMutableArray array];
            
            if (competition.Questions.count > 0) {
            
            for (CompetitionQuestion *question in competition.Questions) {
                
                NSMutableArray *answers = [[NSMutableArray alloc]init];
                
                            NSDictionary *answerItem1 = [NSDictionary dictionaryWithObjectsAndKeys:question.Option1,@"text",[NSNumber numberWithBool:NO],@"marked", nil];
                            [answers addObject:answerItem1];
                
                            NSDictionary *answerItem2 = [NSDictionary dictionaryWithObjectsAndKeys:question.Option2,@"text",[NSNumber numberWithBool:NO],@"marked", nil];
                            [answers addObject:answerItem2];
                            NSDictionary *answerItem3 = [NSDictionary dictionaryWithObjectsAndKeys:question.Option3,@"text",[NSNumber numberWithBool:NO],@"marked", nil];
                            [answers addObject:answerItem3];
                            NSDictionary *answerItem4 = [NSDictionary dictionaryWithObjectsAndKeys:question.Option4,@"text",[NSNumber numberWithBool:NO],@"marked", nil];
                            [answers addObject:answerItem4];
                
                questionItem = [[GWQuestionnaireItem alloc] initWithQuestion:question.Question
                                                                     answers:answers
                                                                        type:GWQuestionnaireSingleChoice questionId:questionItem.questionId];
                questionItem.questionId = question.ID;
                [questions addObject:questionItem];
                
            }
            
            
            questionItem = [[GWQuestionnaireItem alloc] initWithQuestion:@"توضیحات تکمیلی"
                                                                 answers:@[competition.Comment == nil ? @"" : competition.Comment]
                                                                    type:GWQuestionnaireOpenQuestion questionId:@""];
         //   [questions addObject:questionItem];
            
            surveyController = [[GWQuestionnaire alloc] initWithItems:questions];
            
            surveyController.view.frame = CGRectMake(0,self.offset,self.view.frame.size.width,self.view.frame.size.height-self.offset - 20);
            [self.view addSubview:surveyController.view];
            
            }
            
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    [self.getData GetPoll:self.competitionID  withCallback:callback];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self load];
}

-(void)load
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    self.user = [User alloc];
    if (array.count>0) {
        self.user.itemId =[array objectAtIndex:0];
        self.user.mobile = [array objectAtIndex:2];
        self.user.password = [array objectAtIndex:3];
        // self.user.PicThumb = [array objectAtIndex:4];
    }
}

-(void)getAnswersPressed:(id)sender
{
    pollAnswers = [[NSMutableArray alloc]init];
    if(![surveyController isCompleted])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢" message:@"لطفا به تمامی سوالات پاسخ دهید!" delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // NSLog answers
    for(GWQuestionnaireItem *item in surveyController.surveyItems)
    {
        int count = 1;
    
        NSLog(@"-----------------");
        NSLog(@"%@",item.question);
        NSLog(@"-----------------");
        if(item.type == GWQuestionnaireOpenQuestion)
        {
            NSLog(@"Answer: %@", item.userAnswer);
            self.exAnswer = [[NSString alloc]init];
            self.exAnswer = item.userAnswer;
        }
        else
            for(NSDictionary *dict in item.answers)
            {
                
    
                
                if ([[dict objectForKey:@"marked"]boolValue]) {
                    
                  
                    
                    [pollAnswers addObject:[NSString stringWithFormat:@"%d",count]];
                }
                
                NSLog(@"%d - %@",[[dict objectForKey:@"marked"]boolValue], [dict objectForKey:@"text"]);
                count++;
            }
    }
    
    [self SubmitPoll];
}


-(void)SubmitPoll{
    if (self.user.mobile != nil) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicator setColor:[UIColor redColor]];
        [self.view addSubview:activityIndicator];
        activityIndicator.center = self.view.center;
        [activityIndicator startAnimating];
        
        NSDictionary *parameters = @{@"cellphone": self.user.mobile,
                                     @"password": self.user.password,
                                     @"comid": self.competitionID,
                                     @"answers":pollAnswers};
        
        
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        NSString *URLString = ServerURL2;
        
        
        [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Success %@", responseObject);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:[NSString stringWithFormat:@"%@",responseObject]
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        [alert show];
        

        [activityIndicator stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activityIndicator stopAnimating];
        NSLog(@"Failure %@, %@", error, operation.responseString);
    }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                            message:@" ابتدا وارد شوید"
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
