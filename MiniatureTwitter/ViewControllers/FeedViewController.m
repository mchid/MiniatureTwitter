//
//  FeedViewController.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/9/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "FeedViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    
    feedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[self.view frame].size.width,[self.view frame].size.height-49)];
    [feedTableView setDelegate:self];
    [feedTableView setDataSource:self];
    [self.view addSubview:feedTableView];
    
    
    UIBarButtonItem *statusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showNewStatusView)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:statusButton, nil] animated:YES];
    
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFeed)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:refreshButton, nil] animated:YES];
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

- (void)showNewStatusView{
    
}

- (void)refreshFeed{
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
                      NSLog(@"Response : %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                      
                      self.dataSource = [NSJSONSerialization
                                         JSONObjectWithData:responseData
                                         options:NSJSONReadingMutableLeaves
                                        error:&error];
                      
                      if (self.dataSource.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [feedTableView reloadData];
                          });
                      }
                  }];
             }
         } else {
             // Handle failure to get account access
         }
     }];
}

#pragma UITableView Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
        NSDictionary *feed = (NSDictionary *)[self.dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = [feed objectForKey:@"text"];

    return cell;
}

@end
