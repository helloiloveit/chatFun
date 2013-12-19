//
//  FriendListVC.m
//  linphone
//
//  Created by huyheo on 12/19/13.
//
//

#import "FriendListVC.h"
#import "FriendListCustomCell.h"
#import "ChatMainWindow.h"
@interface FriendListVC ()

@end

@implementation FriendListVC

@synthesize friendTableView;
@synthesize friendNameTest;



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = [arryData count];
	if(self.editing) count++;
	return count;
}

// Customize the appearance of table view cells.
- (FriendListCustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    FriendListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    int count = 0;
	if(self.editing && indexPath.row != 0)
		count = 1;
    
    // Set up the cell...
    
	if(indexPath.row == ([arryData count]) && self.editing){
		cell.textLabel.text = @"add new row";
		return cell;
	}
    NSLog(@" info = %@" ,[arryData objectAtIndex:indexPath.row] );
    
	cell.friendName.text  = [arryData objectAtIndex:indexPath.row];
    cell.friendSaying.text = [friendSayingData objectAtIndex:indexPath.row];
    // [cell.friendName setFont: [UIFont fontWithName:font_name_info size:[font_size_info intValue] ]];
    return cell;
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *contactName  = [arryData objectAtIndex:indexPath.row];
    NSLog(@" user name = %@", contactName);
    if ([contactName isEqualToString:@"Huy"]) {
        friendNameTest =HUY_REMOTE_ADDR;
    } else if ([contactName isEqualToString:@"Dung"]) {
        friendNameTest =DUNG_REMOTE_ADDR;   
    } else {
        
        friendNameTest =HUY_REMOTE_ADDR;
    }

    [self goToChattingWindow];
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [arryData removeObjectAtIndex:indexPath.row];
		[friendTableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        //     [arryData insertObject:@"Mac Mini" atIndex:[arryData count]];
		[friendTableView reloadData];
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





-(void)goToChattingWindow
{

    [ self performSegueWithIdentifier: @"go_to_sms_window" sender: NULL];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareforsegue");

    if ([[segue identifier] isEqualToString:@"go_to_sms_window"]){
        NSLog(@"segue to comment page");

        ChatMainWindow *vc = [segue destinationViewController];

       // vc.remoteAddress = @"huynm";
        vc.remoteAddress = friendNameTest;
    }
}
- (void)swipeDetected:(UISwipeGestureRecognizer *)gesture
{
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            // you can include this case too
            break;
        case UISwipeGestureRecognizerDirectionDown:
            // you can include this case too
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        //    [self goToChattingWindow];
            break;
        case UISwipeGestureRecognizerDirectionRight:
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
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    [self.view addGestureRecognizer:swipeRecognizer];
    
    
}

- (void)viewDidLoad
{
    [self initSwipe];
    [super viewDidLoad];
    arryData = [[NSMutableArray alloc] initWithObjects:@"Dung",@"Huy",@"Nam",@"Tuan",nil];
    friendSayingData = [[NSMutableArray alloc] initWithObjects:@"chan qua cu oi",@"di choi ko",@".....",@"CUoi tuan co gi hot",nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
