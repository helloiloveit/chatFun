//
//  TestSendSMSViewController.h
//  Vphone
//
//  Created by huyheo on 11/20/13.
//
//

#import <UIKit/UIKit.h>
#import "linphonecore.h"
#import "HPGrowingTextView.h"

@interface ChatMainWindow : UIViewController <HPGrowingTextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
        LinphoneChatRoom *chatRoom;
    	NSMutableArray *arryData;
        NSMutableArray *fontArrayData;
        NSMutableArray *colorArrayData;
        NSMutableArray *themeColorArrayData;
        NSDictionary   *colorDicData;
}
@property (weak, nonatomic) IBOutlet UITableView *smsTableView;

@property (weak, nonatomic) IBOutlet UITableView *fontListTableView;
@property (weak, nonatomic) IBOutlet UITableView *colorListTableView;
@property (weak, nonatomic) IBOutlet UITableView *themeColorTableView;

- (IBAction)EditTable:(id)sender;



- (IBAction)sendSMS:(id)sender;
- (IBAction)selectStyling:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *stylingSelection;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *stylingButton;

@property (nonatomic, copy) NSString *remoteAddress;


@property (weak, nonatomic) IBOutlet UIView *chatView;

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (retain, nonatomic) IBOutlet HPGrowingTextView *messageField;


//FONT
@property (weak, nonatomic) NSString *fontSize;
@property (weak, nonatomic) NSString *fontTypeName;
@property (weak, nonatomic) NSString *colorCodeName;
@property (weak, nonatomic) NSString *themeColorCodeName;

//Font size
- (IBAction)smallFont:(id)sender;
- (IBAction)mediumFont:(id)sender;
- (IBAction)bigFont:(id)sender;






@end
