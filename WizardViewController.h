//
//  WizardViewController.h
//  linphone
//
//  Created by huyheo on 12/3/13.
//
//

#import <UIKit/UIKit.h>

@interface WizardViewController : UIViewController
- (IBAction)singin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *domainName;
@property (weak, nonatomic) IBOutlet UITextField *loginStatus;

@end
