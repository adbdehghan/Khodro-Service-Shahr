//
//  SignupTableViewCell.h
//  Hyper Me
//
//  Created by aDb on 10/16/15.
//  Copyright © 2015 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupTableViewCell : UITableViewCell

@property (weak, nonatomic)  IBOutlet UITextField *name;
@property (weak, nonatomic)  IBOutlet UITextField *lastname;
@property (weak, nonatomic)  IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic)  IBOutlet UITextField *nationalCode;
@property (weak, nonatomic)  IBOutlet UITextField *username;
@property (weak, nonatomic)  IBOutlet UITextField *password;
@property (weak, nonatomic)  IBOutlet UITextField *email;
@property (weak, nonatomic)  IBOutlet UITextField *address;
@property (weak, nonatomic)  IBOutlet UITextField *postcode;
@property (weak, nonatomic)  IBOutlet UITextField *telNumber;


@end
