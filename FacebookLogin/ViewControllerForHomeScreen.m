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
@synthesize buttonforShareManualPicture;

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

    [labelForFBUSerID setText:[NSString stringWithFormat:@"Facebook ID :- %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FBUserId"]]];
    [labelForFBUserName setText:[NSString stringWithFormat:@"Facebook UserName :- %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FBUserName"]]];
    [labelForFBUserLastName setText:[NSString stringWithFormat:@"Facebook LastName :- %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FBLastName"]]];
    [labelForFBUserEmail setText:[NSString stringWithFormat:@"Facebook Email :- %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FBUserEmail"]]];
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
     @"100000105132554,100004971782748",@"tags",
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

- (IBAction)fnForFBShareBackgroundButtonPressed:(id)sender
{
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // Permission hasn't been granted, so ask for publish_actions
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             if (FBSession.activeSession.isOpen && !error)
                                             {
                                                 // Publish the story if permission was granted
                                                 [self publishStory];
                                             }
                                         }];
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }
}

- (void)publishStory
{
    NSMutableDictionary *postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"http://nightuplife.com/nightup/", @"link",
     @"http://50.19.244.20/nightup_webapp_dev/event/event_images/1367669132.jpg", @"picture",
     @"NightUp gives you quick and easy access to exclusive events. Try it now!.", @"name",
     @"This is all about nightup", @"caption",
     @"I have booked a night out! \nEvent: Last Night in NY \nOn: June 3, 10:30 PM - 04:00 AM", @"message",
     @"100000105132554,100004971782748",@"tags",
     @"121028137918729",@"place",
     nil];
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
     }];

}


- (IBAction)fnForPicUploadButtonPressed:(id)sender
{
    // First check if we can use the native dialog, otherwise will
    // use our own
    BOOL displayedNativeDialog =
    [FBDialogs presentOSIntegratedShareDialogModallyFrom:self initialText:@"" image:[UIImage imageNamed:@"Untitled.png"] url:[NSURL URLWithString:@"https://developers.facebook.com/ios"] handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
        // Only show the error if it is not due to the dialog
        // not being supporte, i.e. code = 7, otherwise ignore
        // because our fallback will show the share view controller.
        if (error && [error code] == 7) {
            return;
        }
        
        NSString *alertText = @"";
        if (error) {
            alertText = [NSString stringWithFormat:
                         @"error: domain = %@, code = %d",
                         error.domain, error.code];
        } else if (result == FBNativeDialogResultSucceeded) {
            alertText = @"Posted successfully.";
        }
        if (![alertText isEqualToString:@""]) {
            // Show the result in an alert
            [[[UIAlertView alloc] initWithTitle:@"Result"
                                        message:alertText
                                       delegate:self
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil]
             show];
        }
    }];
    
    // Fallback, show the view controller that will post using me/feed
    if (!displayedNativeDialog) {
    }

}

- (IBAction)fnForManualPicUploadButtonPressed:(id)sender
{
    UIImage *img = [UIImage imageNamed:@"oab_white.png"];

    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@"Uploading white Image through OAB sample code" forKey:@"message"];
    [params setObject:UIImagePNGRepresentation(img) forKey:@"source"];
    buttonforShareManualPicture.enabled = NO; //for not allowing multiple hits

    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         
         if (error)
         {
             //showing an alert for failure
             NSLog(@"Unable to share the photo please try later.");

         }
         else
         {
             //showing an alert for success
             NSLog(@"Shared the photo successfully");
         }
         buttonforShareManualPicture.enabled = YES;
     }];
}

- (IBAction)fnForPostWithoutAuthButtonPressed:(id)sender;
{
    NSURL* url = [NSURL URLWithString:@"http://www.scan2drive.com"];
    /*[FBDialogs presentShareDialogWithLink:url
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          NSLog(@"Error: %@", error.description);
                                      } else {
                                          NSLog(@"Success!");
                                      }
                                  }];*/
    
    [FBDialogs presentShareDialogWithLink:url name:@"This is OAB test" caption:@"iOS developement" description:@"we can not share more than this" picture:Nil clientState:Nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          NSLog(@"Error: %@", error.description);
                                      } else {
                                          NSLog(@"Success!");
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
