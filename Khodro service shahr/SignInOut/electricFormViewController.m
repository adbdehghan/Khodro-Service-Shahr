//
//  electricFormViewController.m
//  Khodro service shahr
//
//  Created by aDb on 2/15/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "electricFormViewController.h"
#import "DataDownloader.h"
#import "UIWindow+YzdHUD.h"
#import "PDFViewController.h"

@interface electricFormViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSArray *DaysArray;
    
    NSString *currentMonthString;
    
    NSString *month;
    NSString *year;
    NSString *pdfURL;
    
    int selectedYearRow;
    int selectedMonthRow;
    int selectedDayRow;
    
    BOOL firstTimeLoad;
}
@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;
@property (weak, nonatomic) IBOutlet UIView *toolbarCancelDone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEnterDate;
@property(weak,nonatomic) IBOutlet UITextField  *nationalTextField;
@property(weak,nonatomic) IBOutlet UITextField  *driverCodeField;
@property(weak,nonatomic) IBOutlet UITextField  *bankCodeTextField;
@property (strong, nonatomic) DataDownloader *getData;

#pragma mark - IBActions

- (IBAction)actionCancel:(id)sender;

- (IBAction)actionDone:(id)sender;

@end

@implementation electricFormViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     [self CustomizeNavigationBar];
    
    firstTimeLoad = YES;
    self.customPicker.hidden = YES;
    self.toolbarCancelDone.hidden = YES;
    self.textFieldEnterDate.inputView = [[UIView alloc]init];
    
    
//    self.textFieldEnterDate.inputView = self.customPicker;
//    self.textFieldEnterDate.inputAccessoryView = self.toolbarCancelDone;
    
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSPersianCalendar];
    NSDateFormatter *monthFormater = [[NSDateFormatter alloc] init];
    NSLocale *IRLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"];
    [monthFormater setLocale:IRLocal];
    [monthFormater setCalendar:persCalendar];
    NSDate *today = [NSDate date];
    [monthFormater setDateFormat:@"yyyy/MM/dd"];
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    [formatter setCalendar:persCalendar];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    
    yearArray = [[NSMutableArray alloc]init];
    
    
    for (int i = 1300; i <= 1400 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    // PickerView -  Months data
    
    
    monthArray = @[@"فروردین",@"اردیبهشت",@"خرداد",@"تیر",@"مرداد",@"شهریور",@"مهر",@"آبان",@"آذر",@"دی",@"بهمن",@"اسفند	"];
    
    
    [self.customPicker selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:YES];
    
    [self.customPicker selectRow:[[formatter stringFromDate:date]integerValue] inComponent:1 animated:YES];

    
}




- (IBAction)Request:(id)sender
{
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSObject *data) {
        if (wasSuccessful) {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
     
            if ([[((NSDictionary*)data) objectForKey:@"res"] isEqualToString:@"\"-1\""]) {
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"❗️"
                                                                message:@"اطلاعات وارد شده صحیح نمی باشد"
                                                               delegate:self
                                                      cancelButtonTitle:@"تایید"
                                                      otherButtonTitles:nil];
                
                [alert show];
                
            }
            else if ([[((NSDictionary*)data) objectForKey:@"res"] isEqualToString:@"\"0\""])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💡"
                                                                message:@"در این تاریخ فیش موجود نیست"
                                                               delegate:self
                                                      cancelButtonTitle:@"تایید"
                                                      otherButtonTitles:nil];
                
                [alert show];
            
            }
            else
                [self performSegueWithIdentifier:@"showpdf" sender:self];
            
        }
        
        else
        {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"❗️"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید"
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
    };

        
    
    if ([self.driverCodeField.text length]>0 && [self.bankCodeTextField.text length]>0 && [self.nationalTextField.text length]>0 && [self.textFieldEnterDate.text  length]>0) {
        
        [self.getData RequestPayroll:year Month:month DriverCode:self.driverCodeField.text hesabNo:self.bankCodeTextField.text CodeMeli:self.nationalTextField.text withCallback:callback];
        [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"❗️"
                                                        message:@"لطفا مقادیر ورودی را بررسی نمایید"
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }
}



- (void)CustomizeNavigationBar
{
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font =[UIFont fontWithName:@"B Yekan+" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    
    barButtonItem.tintColor = [UIColor whiteColor];
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    
    

    
}

//hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component == 0)
    {
        selectedYearRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.customPicker reloadAllComponents];
    }
    
}
#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 90, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
        pickerLabel.font = [UIFont fontWithName:@"B Yekan+" size:20 ];
        pickerLabel.textColor = [UIColor whiteColor];
        
    }
    
    
    
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 2;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        return [monthArray count];
    }
    
    return 30;
}


-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}



- (IBAction)actionCancel:(id)sender
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
//                         self.textFieldEnterDate.text = birthdate;
                         
                     }];
    
    
    
    
}

- (IBAction)actionDone:(id)sender
{
    month =[NSString stringWithFormat:@"%ld",[self.customPicker selectedRowInComponent:1]+1];
    year =[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]];
    
    self.textFieldEnterDate.text = [NSString stringWithFormat:@"%@/%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]]];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 12) {
        
        [self.view endEditing:YES];
        
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             self.customPicker.hidden = NO;
                             self.toolbarCancelDone.hidden = NO;
                             self.textFieldEnterDate.text = @"";
                             
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        
        self.customPicker.hidden = NO;
        self.toolbarCancelDone.hidden = NO;
        self.textFieldEnterDate.text = @"";
        
        return NO;
    }
    else
        return YES;
    
}


- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PDFViewController *destination = [segue destinationViewController];
    destination.pdfUrl = pdfURL;
}


@end
