//
//  ViewControllerForHomeScreen.m
//  FacebookLogin
//
//  Created by gaurav taywade on 24/04/13.
//  Copyright (c) 2012 www.oabstudios.com. All rights reserved.

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.#import <UIKit/UIKit.h>

#import "ViewControllerForHomeScreen.h"
#import "global.h"
@interface ViewControllerForHomeScreen ()

@end

@implementation ViewControllerForHomeScreen
@synthesize labelForFBUserEmail;
@synthesize labelForFBUSerID;
@synthesize labelForFBUserLastName;
@synthesize labelForFBUserName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setHidden:YES];
    [labelForFBUSerID setText:[NSString stringWithFormat:@"Facebook ID :- %@",FBUserId]];
    [labelForFBUserName setText:[NSString stringWithFormat:@"Facebook UserName :- %@",FBUserName]];
    [labelForFBUserLastName setText:[NSString stringWithFormat:@"Facebook LastName :- %@",FBLastName]];
    [labelForFBUserEmail setText:[NSString stringWithFormat:@"Facebook Email :- %@",FBUserEmail]];
}
#pragma mark - button pressed

- (IBAction)fnForLogOutButtonPressed:(id)sender
{
    [FBSession.activeSession closeAndClearTokenInformation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)fnForFBFriendsButtonPressed:(id)sender
{
    ViewControllerForFaceBookFriends_obj=[[ViewControllerForFaceBookFriends alloc]initWithNibName:@"ViewControllerForFaceBookFriends" bundle:nil Friend_type:@"FB"];
    [self presentViewController:ViewControllerForFaceBookFriends_obj animated:YES completion:nil];
}
- (IBAction)fnForFBAppFriendsButtonPressed:(id)sender
{
    ViewControllerForFaceBookFriends_obj=[[ViewControllerForFaceBookFriends alloc]initWithNibName:@"ViewControllerForFaceBookFriends" bundle:nil Friend_type:@"FBAPP"];
    [self presentViewController:ViewControllerForFaceBookFriends_obj animated:YES completion:nil];
}
- (IBAction)fnForFBShareButtonPressed:(id)sender
{
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"Facebook login sample code", @"name",
     @"Your caption will go here", @"caption",
     @"details description will go here", @"description",
     @"http://oabstudios.com/#home", @"link",
     @"http://oabstudios.com/assest/images/topLogo.png", @"picture",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                     NSLog(@"%@", msg);
                     // Show the result in an alert
                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:@"OK!"
                                       otherButtonTitles:nil]
                      show];
                 }
             }
         }
     }];

}


#pragma mark - for FACEBOOK sharing

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
