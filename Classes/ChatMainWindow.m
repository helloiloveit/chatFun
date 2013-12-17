//
//  TestSendSMSViewController.m
//  Vphone
//
//  Created by huyheo on 11/20/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>

#import "LinphoneAppDelegate.h"
//#import "PhoneMainView.h"
#import "Utils.h"
//#import "DTActionSheet.h"
//#import "ConstantDefinition.h"

#import "ChatMainWindow.h"
#import "LinphoneManager.h"

#import "CustomTableViewCell.h"
#import <Foundation/Foundation.h>

@interface ChatMainWindow ()

@end

@implementation ChatMainWindow

//#define REMOVE_ADDRESS = @"1001";
NSString *const REMOVE_ADDRESS = @"huynm";

NSString *const FONT_TYPE = @"font_type";
NSString *const FONT_SIZE = @"font_size";
NSString *const SMS_INFO = @"sms_info";
NSString *const DIR_INFO = @"direction_info";
NSString *const SENDING = @"sending_sms";
NSString *const RECEIVING = @"receiving_sms";



@synthesize remoteAddress;
@synthesize smsText;
@synthesize sendButton;
@synthesize smsTableView;
@synthesize stylingButton;
@synthesize stylingSelection;
@synthesize fontSize;
@synthesize fontTypeName;

// handle the swipes here
- (void)swipeDetected:(UISwipeGestureRecognizer *)gesture
{
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            // you can include this case too
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self turnOffTyping];
            // you can include this case too
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        case UISwipeGestureRecognizerDirectionRight:
             [self.navigationController popViewControllerAnimated:YES];
            // disable timer for both left and right swipes.
            break;
        default:
            break;
    }
}
-(void)initSwipe
{

    UISwipeGestureRecognizer *swipeRecognizer =
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(swipeDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;

    UISwipeGestureRecognizer *swipeRecognizer2 =
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(swipeDetected:)];
    swipeRecognizer2.direction = UISwipeGestureRecognizerDirectionRight;
    

    
    [self.view addGestureRecognizer:swipeRecognizer2];
     [self.view addGestureRecognizer:swipeRecognizer];
    
    
}

-(void)dismissKeyboard {
    [self.smsText resignFirstResponder];
}
- (void)showKeyboard{
    [self.smsText becomeFirstResponder];
}

- (void)registerForKeyboardNotifications
{
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideShowKeyboard) name:UIKeyboardWillHideNotification object:nil];
}

- (void)willShowKeyboard{
    self.smsText.text = nil;
    [UIView animateWithDuration:0.1
                          delay:0
                        options: 0
                     animations:^{
                         [self.smsText setFrame:CGRectMake(self.stylingButton.frame.size.width, 320   , self.smsText.frame.size.width, self.smsText.frame.size.height )];
                        // [self.sendButton setFrame:CGRectMake(self.stylingButton.frame.size.width +  self.smsText.frame.size.width, 320, self.sendButton.frame.size.width, self.smsText.frame.size.height)];
                          [self.sendButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - self.sendButton.frame.size.width, 320, self.sendButton.frame.size.width, self.sendButton.frame.size.height)];
                         [self.stylingButton setFrame:CGRectMake(0, 320, self.stylingButton.frame.size.width, self.stylingButton.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    /*
    NSLog(@"display position of sendButton  y: %f",self.sendButton.frame.origin.y   );
    NSLog(@"display position of sendButton x : %f",self.sendButton.frame.origin.x   );
    NSLog(@"display position of stylingButton  y: %f",self.stylingButton.frame.origin.y   );
    NSLog(@"display position of stylingButton x : %f",self.stylingButton.frame.origin.x   );
    NSLog(@"display position of window width x : %f",[UIScreen mainScreen].bounds.size.width   );
     */
}
-(void)hideShowKeyboard{
    /*
    [UIView animateWithDuration:0.1
                          delay:0
                        options: 0
                     animations:^{
                         [self.smsText setFrame:CGRectMake(self.stylingButton.frame.size.width, [UIScreen mainScreen].bounds.size.height - self.smsText.frame.size.height   , self.smsText.frame.size.width, self.smsText.frame.size.height )];
                        [self.stylingButton setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.stylingButton.frame.size.height,self.stylingButton.frame.size.width, self.stylingButton.frame.size.height)];
                         [self.sendButton setFrame:CGRectMake(self.stylingButton.frame.size.width +  self.smsText.frame.size.width,[UIScreen mainScreen].bounds.size.height - self.smsText.frame.size.height ,self.sendButton.frame.size.width, self.smsText.frame.size.height)];
                     }
                     completion:^(BOOL finished){

                     }];

*/
}
-(void)turnOffTyping{
    [self.smsText resignFirstResponder];
    self.stylingSelection.hidden = YES;
    [UIView animateWithDuration:0.1
                          delay:0
                        options: 0
                     animations:^{
                         [self.smsText setFrame:CGRectMake(self.stylingButton.frame.size.width, [UIScreen mainScreen].bounds.size.height - self.smsText.frame.size.height   , self.smsText.frame.size.width, self.smsText.frame.size.height )];
                         [self.stylingButton setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.stylingButton.frame.size.height,self.stylingButton.frame.size.width, self.stylingButton.frame.size.height)];
                         [self.sendButton setFrame:CGRectMake(self.stylingButton.frame.size.width +  self.smsText.frame.size.width,[UIScreen mainScreen].bounds.size.height - self.smsText.frame.size.height ,self.sendButton.frame.size.width, self.smsText.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void )initView{
    stylingSelection.hidden = YES;
    
    fontTypeName = @"HelveticaNeue";
    fontSize = @"15";
    
    self.smsText.delegate = self;
    
  //  self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ChatTheme.jpg"]];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"ChatTheme.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //set button position
 //   [self.sendButton setFrame:CGRectMake(self.stylingButton.frame.size.width +  self.smsText.frame.size.width, [UIScreen mainScreen].bounds.size.height , self.sendButton.frame.size.width, self.smsText.frame.size.height)];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    /*
    if (theTextField == self.smsText) {
        [theTextField resignFirstResponder];
    }
     */
    return YES;
}

- (void)viewDidLoad
{
    [self initSwipe];
    [self registerForKeyboardNotifications];
    [self.navigationController setNavigationBarHidden:YES];
    [self initView];
    NSDictionary *dict1 = @{DIR_INFO:SENDING, FONT_TYPE: fontTypeName, FONT_SIZE:fontSize,SMS_INFO:@"live a life"};
    
    
    /*
    for (NSString *familyName in [UIFont familyNames])
    {
        NSLog(@"----------------");
        NSLog(@"FAMILY: %@", familyName);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName])
        {
            NSLog(@"  %@", fontName);
        }
    }*/
    
    

//    arryData = [[NSMutableArray alloc] initWithObjects:@"iPhone",@"iPod",@"MacBook",@"MacBook Pro",nil];
    arryData = [[NSMutableArray alloc] initWithObjects:dict1,dict1,dict1,dict1,nil];
    fontArrayData =[[NSMutableArray alloc] initWithObjects:@"HiraKakuProN-W6",@"Cochin-Italic",@"STHeitiSC-Light",@"BradleyHandITCTT-Bold", @"Noteworthy-Light", @"Zapfino", nil];
    [super viewDidLoad];
    


    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textReceived:)
                                                 name:kLinphoneTextReceived
                                               object:nil];
	// Do any additional setup after loading the view.
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)readHeaderOfSms: (NSString *)smsData {
    NSLog(@"smsDatea= %@", smsData);
    
    NSData *jsonData = [smsData dataUsingEncoding:NSUTF8StringEncoding];
    // DebugLog(@"json data = %@", [jsonData description]);
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    //DebugLog(@"result = %@", [results description]);
    NSLog(@"results = %@", results);
    NSLog(@"font ype = %@ font size = %@", results[FONT_SIZE],results[FONT_TYPE]);
    //fontSize = results[FONT_SIZE];
    //fontTypeName = results[FONT_TYPE];
    @try {
        NSDictionary *temp_dic = @{DIR_INFO:RECEIVING,FONT_TYPE:results[FONT_TYPE],FONT_SIZE:results[FONT_SIZE],SMS_INFO:results[SMS_INFO]};
        return temp_dic;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        return nil;
    }
    @finally {

    }
    

   // return temp_dic;

    
}

- (void)textReceived:(NSNotification*)notif {
    //receive new sms
    //update view
    NSString *smsInfo = [notif userInfo][@"message"];
    NSLog(@"receive new sms");
    NSDictionary *smsDic = [self readHeaderOfSms: smsInfo];
    if (smsDic) {
        [arryData addObject:smsDic];
        [arryData removeObjectAtIndex:0];
        [smsTableView reloadData];
    }
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.fontListTableView) {
        int count = [fontArrayData count];
        return count;
    } else {
        int count = [arryData count];
        if(self.editing) count++;
        return count;
    }

}

// Customize the appearance of table view cells.
- (CustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    


    int count = 0;
	if(self.editing && indexPath.row != 0)
		count = 1;

    // Set up the cell...
    
	if(indexPath.row == ([arryData count]) && self.editing){
		cell.textLabel.text = @"add new row";
		return cell;
	}
    // to make cell tranpearent in iOs 7
    cell.backgroundColor = [UIColor clearColor];
    if (tableView == self.fontListTableView) {
        
        NSString *font_name_info = [fontArrayData objectAtIndex:indexPath.row];

        [cell.textLabel setFont: [UIFont fontWithName:font_name_info size:14 ]];
        cell.textLabel.text = @"live a life";
        return cell;
        
    }
    
   // NSLog(@"check dic = %@",[arryData objectAtIndex:indexPath.row] );
    NSString *font_name_info = [arryData objectAtIndex:indexPath.row][FONT_TYPE];
    NSString *font_size_info = [arryData objectAtIndex:indexPath.row][FONT_SIZE];
    NSString *sms_data_info = [arryData objectAtIndex:indexPath.row][SMS_INFO];
    //NSLog(@"font_name_info = %@", font_name_info);
	cell.textData.text  = sms_data_info;
    [cell.textData setFont: [UIFont fontWithName:font_name_info size:[font_size_info intValue] ]];
    cell.textData.textColor = [UIColor whiteColor];
    if ([[arryData objectAtIndex:indexPath.row][DIR_INFO] isEqualToString:RECEIVING]  ) {
            cell.textData.textAlignment = NSTextAlignmentRight;
    } else {
        cell.textData.textAlignment = NSTextAlignmentLeft;
    }
    return cell;
}

- (IBAction)AddButtonAction:(id)sender{
//	[arryData addObject:@"Mac Mini"];
	[smsTableView reloadData];
}

- (IBAction)DeleteButtonAction:(id)sender{
	[arryData removeLastObject];
	[smsTableView reloadData];
}


- (IBAction)EditTable:(id)sender {
	if(self.editing)
	{
		[super setEditing:NO animated:NO];
		[smsTableView setEditing:NO animated:NO];
		[smsTableView reloadData];

	}
	else
	{
		[super setEditing:YES animated:NO];
		[smsTableView setEditing:YES animated:NO];
		[smsTableView reloadData];

	}
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    /*
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already
    // existing content. Existing content can be deleted.
    
    if (self.editing && indexPath.row == ([arryData count])) {
		return UITableViewCellEditingStyleInsert;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
    */
    return UITableViewCellEditingStyleNone;
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [arryData removeObjectAtIndex:indexPath.row];
		[smsTableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
   //     [arryData insertObject:@"Mac Mini" atIndex:[arryData count]];
		[smsTableView reloadData];
    }
}

#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {
	NSString *item = [arryData objectAtIndex:fromIndexPath.row] ;
	[arryData removeObject:item];
	[arryData insertObject:item atIndex:toIndexPath.row];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.fontListTableView) {
        NSString *font_name_info = [fontArrayData objectAtIndex:indexPath.row];
        fontTypeName = font_name_info;
        [self.smsText setFont:[UIFont fontWithName:font_name_info size:[fontSize intValue]]];
    }
}


- (IBAction)sendSMS:(id)sender {
    NSDictionary *smsPDU = @{FONT_TYPE :fontTypeName, FONT_SIZE : fontSize, SMS_INFO : smsText.text};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:smsPDU
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self sendMessage:jsonString withExterlBodyUrl:nil withInternalUrl:nil] ;

    }
    

    NSDictionary *text_data_unit = @{DIR_INFO:SENDING, FONT_TYPE: fontTypeName, FONT_SIZE: fontSize, SMS_INFO:smsText.text};
    [arryData addObject:text_data_unit];
    [arryData removeObjectAtIndex:0];
	[smsTableView reloadData];
}

- (IBAction)selectStyling:(id)sender {

    NSLog(@"styling pos = %f", stylingButton.frame.origin.y);
    if (stylingButton.frame.origin.y == YES) {
        stylingSelection.hidden = NO;
        //[self dismissKeyboard];
        [self showKeyboard];

        
    } else {
        stylingSelection.hidden = NO;
        //[self showKeyboard];
        [self dismissKeyboard];
    }
}

- (void)setRemoteAddress:(NSString*)aRemoteAddress {
    if ([aRemoteAddress hasPrefix:@"sip:"]) {
        remoteAddress = [aRemoteAddress copy];
    } else {
        char normalizedUserName[256];
        LinphoneCore *lc = [LinphoneManager getLc];
        LinphoneProxyConfig* proxyCfg;
        linphone_core_get_default_proxy(lc,&proxyCfg);
        LinphoneAddress* linphoneAddress = linphone_address_new(linphone_core_get_identity(lc));
        linphone_proxy_config_normalize_number(proxyCfg, [aRemoteAddress cStringUsingEncoding:[NSString defaultCStringEncoding]], normalizedUserName, sizeof(normalizedUserName));
        linphone_address_set_username(linphoneAddress, normalizedUserName);
        remoteAddress = [@(linphone_address_as_string_uri_only(linphoneAddress)) copy];
        linphone_address_destroy(linphoneAddress);
    }

}

- (BOOL)sendMessage:(NSString *)message withExterlBodyUrl:(NSURL*)externalUrl withInternalUrl:(NSURL*)internalUrl {
    NSLog(@"SENDING \n\n\n");
    remoteAddress = REMOVE_ADDRESS;
    if(chatRoom == NULL) {
		chatRoom = linphone_core_create_chat_room([LinphoneManager getLc], [remoteAddress UTF8String]);
    }
    
    
    NSLog(@"sendding sms = %@", message);
    
    NSString *temp = nil;
    LinphoneChatMessage* msg = linphone_chat_room_create_message(chatRoom, [message UTF8String]);
	linphone_chat_message_set_user_data(msg, (__bridge void *)(temp));
    if(externalUrl) {
        linphone_chat_message_set_external_body_url(msg, [[externalUrl absoluteString] UTF8String]);
    }
	linphone_chat_room_send_message2(chatRoom, msg, message_status, (__bridge void *)(self));
    return TRUE;
}
static void message_status(LinphoneChatMessage* msg,LinphoneChatMessageState state,void* ud) {
    /*
    NSLog(@"Status change \n\n\n");
	ChatRoomViewController* thiz = (ChatRoomViewController*)ud;
	ChatModel *chat = (ChatModel *)linphone_chat_message_get_user_data(msg);
	[LinphoneLogger log:LinphoneLoggerLog
				 format:@"Delivery status for [%@] is [%s]",(chat.message?chat.message:@""),linphone_chat_message_state_to_string(state)];
	[chat setState:[NSNumber numberWithInt:state]];
	[chat update];
	[thiz.tableController updateChatEntry:chat];
	if (state != LinphoneChatMessageStateInProgress) {
		linphone_chat_message_set_user_data(msg, NULL);
		[chat release]; // no longuer need to keep reference
	}
	*/
}
- (IBAction)smallFont:(id)sender {
    fontSize = @"15";
    [self.smsText setFont:[UIFont fontWithName:fontTypeName size:[fontSize intValue]]];

}

- (IBAction)mediumFont:(id)sender {
    fontSize = @"25";
    [self.smsText setFont:[UIFont fontWithName:fontTypeName size:[fontSize intValue]]];
}

- (IBAction)bigFont:(id)sender {
    fontSize = @"30";
    [self.smsText setFont:[UIFont fontWithName:fontTypeName size:[fontSize intValue]]];
}


- (IBAction)fontType1:(id)sender {
    fontTypeName = @"HiraginoKakuGothicProNW3";
    [self.smsText setFont:[UIFont fontWithName:fontTypeName size:[fontSize intValue]]];
    
}

- (IBAction)fontType2:(id)sender {
    fontTypeName = @"Thonburi";
    [self.smsText setFont:[UIFont fontWithName:fontTypeName size:[fontSize intValue]]];
}

- (IBAction)fontType3:(id)sender {
    fontTypeName = @"HeitiTCLight";
    [self.smsText setFont:[UIFont fontWithName:fontTypeName size:[fontSize intValue]]];
}

- (IBAction)fontType4:(id)sender {
    fontTypeName = @"Palatino";
    [self.smsText setFont:[UIFont fontWithName:fontTypeName size:[fontSize intValue]]];
}
@end
