//
//  ViewControllerForFaceBookFriends.h
//  FacebookLogin
//
//  Created by Gaurav Taywade on 26/04/13.
//  Copyright (c) 2013 Gaurav taywade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewControllerForFaceBookFriends : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSString *FriendType;
}

@property (nonatomic, strong) IBOutlet UITableView *FBFriendListTableView;
@property (strong, nonatomic) NSArray *FBFriendsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Friend_type:(NSString*)type;

- (IBAction)fnForBackButtonPressed:(id)sender;

@end
