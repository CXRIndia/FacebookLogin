//
//  ViewControllerForFBLogin.m
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

#import "ViewControllerForFBLogin.h"
#import "AppDelegate.h"

@interface ViewControllerForFBLogin ()

@end

@implementation ViewControllerForFBLogin

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

}

#pragma mark - Login Button

- (IBAction)fnForLoginButtonPressed:(id)sender
{
    // Check Reachability
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSessionWithAllowLoginUI:YES];

}

-(void)LoadDashBoardScreen
{
    ViewControllerForHomeScreen_obj=[[ViewControllerForHomeScreen alloc]initWithNibName:@"ViewControllerForHomeScreen" bundle:nil];
    [self.navigationController pushViewController:ViewControllerForHomeScreen_obj animated:YES];
}

- (void)loginFailed
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
