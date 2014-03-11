//
//  SearchViewController.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/9/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "SearchViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize currentResponder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    self.title = @"Follow";
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 300, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"enter text";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeySearch;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [self.view addSubview:textField];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}


//Todo : Request call is almost the same except the url and parameters. Refactor the code.
- (void)textFieldDidEndEditing:(UITextField *)textField{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =
                 [arrayOfAccounts lastObject];
                 
                 NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"];
                 
                 NSMutableDictionary *parameters =
                 [[NSMutableDictionary alloc] init];
                 [parameters setObject:textField.text forKey:@"screen_name"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:parameters];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      NSLog(@"Response : %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                      
                      id dataSource = [NSJSONSerialization
                                       JSONObjectWithData:responseData
                                       options:NSJSONReadingMutableLeaves
                                       error:&error];
                      
                      
                      if (dataSource) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self processData:dataSource];
                          });
                      }
                  }];
             }
         } else {
             // Handle failure to get account access
         }
     }];
}


- (void) processData:(id)dataSource{
    NSDictionary *userDict = (NSDictionary*)dataSource;
    NSArray *errorArray = [userDict objectForKey:@"errors"];
    if(!errorArray){
        [self showAlert:@"You are now following this user." title:@""];
    }
    else{
        if([errorArray count]){
            NSDictionary *errorDict = [errorArray objectAtIndex:0];
            [self showAlert:[errorDict objectForKey:@"message"] title:@"Error"];
        }

    }
}

//Todo : Remove multiple show message methods in the app.
- (void)showAlert:(NSString*)message title:(NSString*)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    });
}

@end
