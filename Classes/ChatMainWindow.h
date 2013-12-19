//
//  TestSendSMSViewController.h
//  Vphone
//
//  Created by huyheo on 11/20/13.
//
//

#import <UIKit/UIKit.h>
#import "linphonecore.h"

@interface ChatMainWindow : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
        LinphoneChatRoom *chatRoom;
    	NSMutableArray *arryData;
        NSMutableArray *fontArrayData;
}
@property (weak, nonatomic) IBOutlet UITableView *smsTableView;

@property (weak, nonatomic) IBOutlet UITableView *fontListTableView;

- (IBAction)EditTable:(id)sender;



- (IBAction)sendSMS:(id)sender;
- (IBAction)selectStyling:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *stylingSelection;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *stylingButton;

@property (nonatomic, copy) NSString *remoteAddress;

@property (weak, nonatomic) IBOutlet UITextField *smsText;

//FONT
@property (weak, nonatomic) NSString *fontSize;
@property (weak, nonatomic) NSString *fontTypeName;
//Font size
- (IBAction)smallFont:(id)sender;
- (IBAction)mediumFont:(id)sender;
- (IBAction)bigFont:(id)sender;


//Font type
- (IBAction)fontType1:(id)sender;
- (IBAction)fontType2:(id)sender;
- (IBAction)fontType3:(id)sender;
- (IBAction)fontType4:(id)sender;




@end
