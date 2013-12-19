//
//  FriendListVC.h
//  linphone
//
//  Created by huyheo on 12/19/13.
//
//

#import <UIKit/UIKit.h>
#import "ConstantDefinition.h"

@interface FriendListVC : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *arryData;
    NSMutableArray *friendSayingData;
}
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (weak, nonatomic) NSString *friendNameTest;

@end
