//
//  ProfileTableViewController.m
//  Khodro service shahr
//
//  Created by aDb on 1/3/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "RSKImageCropViewController.h"
#import "MMCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "DBManager.h"
#import "Settings.h"
#import "DataDownloader.h"
#import "User.h"
#import "NYAlertViewController.h"

static NSString *const ServerURL = @"http://khodroservice.kara.systems/api/mobile/UploadUserPic";
@interface ProfileTableViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate>
{
    User *user;
    NSString *name;
    NSURL *imageURL;
}
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation ProfileTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreateMenuButton];
    
    self.navigationItem.hidesBackButton = YES;

    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"B Yekan+" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;

    self.tableView.estimatedRowHeight = 60;
    
    name = [self load][1];
    
    user = [User alloc];
    user.mobile = [self load][2];
    user.password = [self load][3];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 5:
            [self performSegueWithIdentifier:@"gps" sender:self];
            break;
        case 7:
            [self showCustomUIAlertView];
            break;
    }
}

-(NSMutableArray*)load
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    return array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.estimatedRowHeight = 35;
    
    // self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    switch (indexPath.row) {
        case 0:
        {
            
            static NSString *cellIdentifier = @"ProfileCellIdentifier";
            
            MMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if (cell==nil) {
                cell = [[MMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            
            cell.mmimageView.image = [self loadCustomObjectWithKey:@"propic"];
            cell.mmimageView.layer.cornerRadius = cell.mmimageView.frame.size.width / 2;
            cell.mmimageView.layer.masksToBounds = YES;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
           // [cell.activityView startAnimating];
            //cell.startTimeLabel.text = st.settingId;
            
            cell.mmlabel.text =name;
            
      
            
            return cell;
        }
            break;
            
        case 1:
        {
            static NSString *cellIdentifier = @"ChangePicCellIdentifier";
            MMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if (cell==nil) {
                
                cell = [[MMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.coinButton addTarget:self action:@selector(ChangePic:)forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        case 2:
        {
            static NSString *cellIdentifier = @"EmptyCellIdentifier1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if (cell==nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        case 3:
        {
            static NSString *cellIdentifier = @"PersonalCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if (cell==nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            return cell;
        }
        case 4:
        {
            static NSString *cellIdentifier = @"InviteCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if (cell==nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            return cell;
        }
        case 5:
        {
            static NSString *cellIdentifier = @"AboutCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if (cell==nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            return cell;
        }
        case 6:
        {
            static NSString *cellIdentifier = @"EmptyCellIdentifier2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if (cell==nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        case 7:
        {
            
            static NSString *cellIdentifier = @"LogoutCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if (cell==nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            
            return cell;
        }
            
        default:
            return nil;
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            return 176;
        }
            break;
            
        case 1:
        {     return 40;
        }
        case 2:
        {
            
            return 20;
        }
        case 3:
        {
            return 57;
        }
        case 4:
        {   return 57;
        }
        case 5:
        {   return 57;
        }
        case 6:
        {   return 20;
        }
        case 7:
        {
            
            
            return 47;
        }
            
        default:
            return 50;
            break;
    }
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // this UIViewController is about to re-appear, make sure we remove the current selection in our table view
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

-(void)CreateMenuButton
{
    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingImage = [[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuButton setImage:settingImage forState:UIControlStateNormal];
    
    menuButton.tintColor = [UIColor whiteColor];
    [menuButton addTarget:self action:@selector(GoToMenu)forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 24, 24)];
    
    
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = settingBarButton;
    
    
}

-(void)GoToMenu
{
    
    [self performSegueWithIdentifier:@"first" sender:self];
}

-(void)ChangePic:(id)sender
{
    
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"لغو"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"انتخاب",@"عکس بگیر" ,nil];
    [choiceSheet showInView:self.view];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:portraitImg];
        
        imageCropVC.delegate = self;
        
        [self.navigationController pushViewController:imageCropVC animated:YES];
        
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 0) {
        
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MMCell *cell = (MMCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.mmimageView.image = croppedImage;
    cell.mmimageView.alpha = .3;
    [cell.activityView startAnimating];
    
    [self PostPicture:croppedImage];
    
    // [self.addPhotoButton setImage:croppedImage forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)PostPicture:(UIImage*)imageToSend
{
    NSString *fileName = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    
    NSDictionary *parameters = @{@"cellphone": user.mobile,
                                 @"password": user.password};
    
    NSString *URLString = ServerURL;
    
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer]
                             multipartFormRequestWithMethod:
                             @"POST" URLString:URLString
                             parameters:parameters
                             constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                 [formData
                                  appendPartWithFileData:UIImageJPEGRepresentation(imageToSend, .6)
                                  name:@"uploadedfile"
                                  fileName:fileName
                                  mimeType:@"jpg"];
                             } error:(NULL)];
    
    AFHTTPRequestOperation *operation =
    [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
                                               id responseObject) {
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        MMCell *cell = (MMCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.mmimageView.alpha = 1;
        cell.mmimageView.image = imageToSend;
        [cell.activityView stopAnimating];
        [self saveCustomObject:imageToSend key:@"propic"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failure %@, %@", error, operation.responseString);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"📢"
                                                        message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                       delegate:self
                                              cancelButtonTitle:@"خب"
                                              otherButtonTitles:nil];
        [alert show];
        
        
        
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    
    [operation start];
    
    
}

- (void)saveCustomObject:(UIImage *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (UIImage *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    UIImage *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCustomUIAlertView {
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(@"خروج", nil);
    alertViewController.message = NSLocalizedString(@"آیا مطمئن هستید؟", nil);
    
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"B Yekan+" size:18];
    alertViewController.messageFont = [UIFont fontWithName:@"B Yekan+" size:16];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"B Yekan+" size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"B Yekan+" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.alertViewBackgroundColor =[UIColor colorWithWhite:0.19f alpha:1.0f];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:242/255.f green:172/255.f blue:63/255.f alpha:1.f];//[UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    
    alertViewController.buttonColor =[UIColor colorWithRed:240/255.f green:166/255.f blue:50/255.f alpha:1.f]; //[UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.buttonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    alertViewController.cancelButtonColor = [UIColor colorWithRed:240/255.f green:166/255.f blue:50/255.f alpha:1.f];//[UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.cancelButtonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"بله", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [self Clear];
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              [self performSegueWithIdentifier:@"signin" sender:self];

                                                          }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"خیر", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
                                                              [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

-(void)Clear
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    
    [array writeToFile:plistPath atomically: TRUE];
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}



@end
