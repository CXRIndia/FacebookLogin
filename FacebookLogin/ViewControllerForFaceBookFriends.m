//
//  ViewControllerForFaceBookFriends.m
//  FacebookLogin
//
//  Created by Gaurav Taywade on 26/04/13.
//  Copyright (c) 2013 Gaurav taywade. All rights reserved.
//

#import "ViewControllerForFaceBookFriends.h"

@interface ViewControllerForFaceBookFriends ()

@end

@implementation ViewControllerForFaceBookFriends
@synthesize FBFriendListTableView;
@synthesize FBFriendsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Friend_type:(NSString*)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FriendType=type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([FriendType isEqualToString:@"FB"])
    {
        [self FetchFBFriends];
    }
    else if ([FriendType isEqualToString:@"FBAPP"])
    {
        [self FetchFBAPPFriends];
    }
}

#pragma mark - button pressed

- (IBAction)fnForBackButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)FetchFBFriends
{
    
    // Query to fetch the active user's friends, limit to 25.
    NSString *query =
    @"SELECT uid, name, pic_square FROM user WHERE is_app_user=0 AND uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ";
    // Set up the query parameter
    NSDictionary *queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  NSLog(@"Result: %@", result);
                                  FBFriendsArray = (NSArray *) [result objectForKey:@"data"];
                                  //NSLog(@"FBFriendsArray %@",FBFriendsArray);
                                  [FBFriendListTableView reloadData];
                                  
                              }
                          }];
}

-(void)FetchFBAPPFriends
{
    
    // Query to fetch the active user's friends, limit to 25.
    NSString *query =
    @"SELECT uid, name, pic_square FROM user WHERE is_app_user=1 AND uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ";
    // Set up the query parameter
    NSDictionary *queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  NSLog(@"Result: %@", result);
                                  FBFriendsArray = (NSArray *) [result objectForKey:@"data"];
                                  //NSLog(@"FBFriendsArray %@",FBFriendsArray);
                                  [FBFriendListTableView reloadData];
                                  
                              }
                          }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [FBFriendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell.textLabel setText:[[FBFriendsArray objectAtIndex:indexPath.row]
                                 objectForKey:@"name"]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Arial" size:16.0f]];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // For Inviting friends
    // Navigation logic may go here. Create and push another view controller.
    NSString *to =[NSString stringWithFormat:@"%@",[[FBFriendsArray objectAtIndex:indexPath.row]
                                                    objectForKey:@"uid"]];
    
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     to , @"to",
                                     nil];
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:[NSString stringWithFormat:@"I'm using OAB sample app to send you request"]
                                                    title:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Case A: Error launching the dialog or sending request.
                                                          NSLog(@"Error sending request.");
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          } else {
                                                              NSLog(@"Request Sent.");
                                                              ;
                                                          }
                                                      }}];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
