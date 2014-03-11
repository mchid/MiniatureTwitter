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
#import "Feed.h"
#import "User.h"
#import "FeedCell.h"
#import "StatsViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize feedArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
     [super viewDidLoad];
    
    self.title = @"Timeline";
    
    UIBarButtonItem *statusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showNewStatusView)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:statusButton, nil] animated:YES];
    
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFeed)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:refreshButton, nil] animated:YES];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshFeed)
             forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing Timeline..."];
    self.refreshControl = refreshControl;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator setFrame:[self.view bounds]];
    [self.view addSubview:activityIndicator];
    [activityIndicator setHidesWhenStopped:YES];
    [activityIndicator startAnimating];
    [activityIndicator setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    
    [self refreshFeed];
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

- (void)processData:(id)dataSource{
    
    [self.refreshControl endRefreshing];
    [activityIndicator stopAnimating];
    
    if(!feedArray)
        feedArray = [[NSMutableArray alloc] init];
    for(NSDictionary *feedDict in dataSource){
        Feed *feed = [[Feed alloc] init];
        [feed setPubDate:[feedDict objectForKey:@"created_at"]];
        [feed setText:[feedDict objectForKey:@"text"]];
         
         NSDictionary *userDict = [feedDict objectForKey:@"user"];
         
         User *user = [[User alloc] init];
         [user setScreenName:[userDict objectForKey:@"screen_name"]];
         [user setLocation:[userDict objectForKey:@"location"]];
         [user setDescription:[userDict objectForKey:@"description"]];
         [user setFollowersCount:[[userDict objectForKey:@"followers_count"] intValue]];
         [user setFriendsCount:[[userDict objectForKey:@"friends_count"] intValue]];
         [user setStatusCount:[[userDict objectForKey:@"statuses_count"] intValue]];
         [user setProfileImageUrl:[userDict objectForKey:@"profile_image_url"]];
         [user setFollowing:[[userDict objectForKey:@"following"] boolValue]];
         [user setFollowRequestSent:[[userDict objectForKey:@"follow_request_sent"] boolValue]];
         
         [feed setUser:user];
        
        [self.feedArray addObject:feed];
         
    }
    [self.tableView reloadData];
}

- (CGFloat)getHeight:(Feed*)feed{
    NSString *screenName = [[feed user] screenName];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:16.0];
    CGRect nameRect = [screenName boundingRectWithSize:CGSizeMake(260,100)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:boldFont}
                                               context:nil];
    
    
    NSString *textFeed = [feed text];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGRect textRect = [textFeed boundingRectWithSize:CGSizeMake(260,1000)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil];
    return nameRect.size.height + textRect .size.height+5;
}

#pragma UITableView Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return feedArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Feed *feed = [self.feedArray objectAtIndex:indexPath.row];
    return [self getHeight:feed];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil) {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    Feed *feed = [self.feedArray objectAtIndex:indexPath.row];
    [cell setUpContents:feed];
    
    return cell;
}

#pragma UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StatsViewController *statsController = [[StatsViewController alloc] initWithFeed:[feedArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:statsController animated:YES];
}


@end
