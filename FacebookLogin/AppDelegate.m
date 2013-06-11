//
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "global.h"

NSString *const SCSessionStateChangedNotification = @"com.oabtesting.FacebookLogin:SCSessionStateChangedNotification";

@implementation AppDelegate
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    ViewControllerForFBLogin_obj=[[ViewControllerForFBLogin alloc]initWithNibName:@"ViewControllerForFBLogin" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:ViewControllerForFBLogin_obj];
    self.window.rootViewController = self.navigationController;

    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        
        [self openSessionWithoutAllowLoginUI:NO];
        [ViewControllerForFBLogin_obj LoadDashBoardScreen];
    }
    
    [self.window makeKeyAndVisible];
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession handleDidBecomeActive];

}

#pragma mark Facebook Login Code

- (void)createAndPresentLoginView {
    
    if (ViewControllerForFBLogin_obj == nil)
    {
        ViewControllerForFBLogin_obj=[[ViewControllerForFBLogin alloc]initWithNibName:@"ViewControllerForFBLogin" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:ViewControllerForFBLogin_obj];
        self.navigationController.navigationBarHidden=YES;
        self.window.rootViewController = self.navigationController;
    }
}

- (void)showLoginView {
    if (ViewControllerForFBLogin_obj == nil)
    {
        [self createAndPresentLoginView];
    } else
    {
        [ViewControllerForFBLogin_obj loginFailed];
    }
}



- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    switch (state) {
            
        case FBSessionStateOpen:
        {
            
            if (ViewControllerForFBLogin_obj != nil) {
                
                if (FBSession.activeSession.isOpen) {
                    [[FBRequest requestForMe] startWithCompletionHandler:
                     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                         if (!error) {
                             
                             NSLog(@"%@,%@,%@",[user objectForKey:@"id"],[user objectForKey:@"email"],user.first_name);
                             
                             FBUserId=[user objectForKey:@"id"];
                             FBUserName=user.first_name;
                             FBLastName=user.last_name;
                             FBUserEmail=[user objectForKey:@"email"];

                             [ViewControllerForFBLogin_obj LoadDashBoardScreen];
                         }
                     }];
                }
                
            }
            
        }
            break;
            
            
        case FBSessionStateClosed:
        {
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self performSelector:@selector(showLoginView)
                       withObject:nil
                       afterDelay:0.5f];
        }
            break;
            
            
        case FBSessionStateClosedLoginFailed:
        {
            [self performSelector:@selector(showLoginView)
                       withObject:nil
                       afterDelay:0.5f];
            
        }
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification
                                                        object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %@",
                                                                     [AppDelegate FBErrorCodeDescription:error.code]]
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [self fbResync];
        
    }
}

-(void)fbResync
{
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %@",
                                                                                 [AppDelegate FBErrorCodeDescription:error.code]]
                                                                        message:error.localizedDescription
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    
                    
                }
            }];
        }
    }
}
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
}

- (BOOL)openSessionWithoutAllowLoginUI:(BOOL)allowLoginUI
{
    
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             //[self sessionStateChanged:session state:state error:error];
                                         }];
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    return [FBSession.activeSession handleOpenURL:url];
}

+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code {
    switch(code){
        case FBErrorInvalid :{
            return @"FBErrorInvalid";
        }
        case FBErrorOperationCancelled:{
            return @"FBErrorOperationCancelled";
        }
        case FBErrorLoginFailedOrCancelled:{
            return @"FBErrorLoginFailedOrCancelled";
        }
        case FBErrorRequestConnectionApi:{
            return @"FBErrorRequestConnectionApi";
        }case FBErrorProtocolMismatch:{
            return @"FBErrorProtocolMismatch";
        }
        case FBErrorHTTPError:{
            return @"FBErrorHTTPError";
        }
        case FBErrorNonTextMimeTypeReturned:{
            return @"FBErrorNonTextMimeTypeReturned";
        }
            //        case FBErrorNativeDialog:{
            //            return @"FBErrorNativeDialog";
            //        }
        default:
            return @"[Unknown]";
    }
}


@end
