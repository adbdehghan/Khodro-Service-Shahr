//
//  GWQuestionnaireCellTextField.h
//
//  Created by Grzegorz Wójcik on 10.03.2014.
//
//

#import <UIKit/UIKit.h>
#import "GWQuestionnaireItem.h"
#import "GWQuestionnaire.h"

@interface GWQuestionnaireCellTextField : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *textField;

-(void)setOwner:(GWQuestionnaire*)val;
-(void)setContent:(GWQuestionnaireItem*)item row:(int)r;
@end
// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net