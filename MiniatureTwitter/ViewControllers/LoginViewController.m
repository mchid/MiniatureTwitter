//
//  LoginViewController.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/7/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "LoginViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = backgroundView;
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    [self getTimeLine];
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


- (void)getTimeLine {
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
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 
                 NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"];
                 
                 NSMutableDictionary *parameters =
                 [[NSMutableDictionary alloc] init];
                 [parameters setObject:@"20" forKey:@"count"];
                 [parameters setObject:@"1" forKey:@"include_entities"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      NSLog(@"Response String: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
//                      self.dataSource = [NSJSONSerialization
//                                         JSONObjectWithData:responseData
//                                         options:NSJSONReadingMutableLeaves
//                                         error:&error];
//                      
//                      if (self.dataSource.count != 0) {
//                          dispatch_async(dispatch_get_main_queue(), ^{
//                              [self.tweetTableView reloadData];
//                          });
//                      }
                  }];
             }
             else{
                 NSLog(@"No accounts configured.");
             }
         } else {
             // Handle failure to get account access
           
            NSLog(@"Twitter not configured. Go to settings to add a twitter account.");
             
             
         }
     }];
}

@end
