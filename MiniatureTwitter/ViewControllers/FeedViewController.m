//
//  FeedViewController.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "FeedViewController.h"
#import "Tweet.h"
#import "User.h"
#import "FeedCell.h"
#import "DownloadQueue.h"
#import "Trend.h"

#define USER_NAME_FONT_SIZE 18.0
#define TWEET_FONT_SIZE 12.0
#define Y_OFFSET 5.0
#define MAX_WIDTH 310
#define MAX_HEIGHT 1000

@interface FeedViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *pageType;
@property (nonatomic,strong) NSString *searchTerm;

@end

@implementation FeedViewController
@synthesize dataArray, pageType, searchTerm;

// The same FeedViewController is used for both Trends page and Tweets page. So it can be initialized by passign either "Trends" or "Tweets".
// The query parameter can be nil in case of "Trends" page.
// Have hardcoded the woeid for california to get the top trends over there.
- (id)initForPage:(NSString*)page query:(NSString*)query{
    if (self = [super init]) {
        self.pageType = page;
        self.searchTerm = query;
    }
    return self;
}

// Controls are added - Refresh bar button and pull to refresh control.
// The selectors to execute when a touch/pull event occurs is decided based on the page.
- (void)viewDidLoad{
     [super viewDidLoad];
   
    SEL selector = nil;
    if([self.pageType isEqualToString:@"Trends"]){
        self.title = @"Trends";
        selector = @selector(getTrends);
    }
    else{
        self.title = @"Tweets";
        selector = @selector(refreshFeed);
    }
    
    //Refresh button at the top right corner. Allows the tweets to be reloaded. Clicking will invoke a network call.
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:selector];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:refreshButton, nil] animated:YES];

    //Same functionality as refresh button. But instead of pressing a button, the user pulls the table view down and releases it.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:selector
             forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing Timeline..."];
    self.refreshControl = refreshControl;
    
    [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
}

// Calls the trendRequestWithCompletionHandler on the singleton downloadqueue which is a subclass of NSOperationQueue.
// Also passes a block to execute when the download is complete.
// The view is refreshed in the main queue after download.
- (void)getTrends{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[DownloadQueue getDownloadQueue] trendRequestWithCompletionHandler:^(id dataSource){
        NSLog(@"Trends downloaded");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadTrends:dataSource];
        });
    }];
}

// Update the model from the results and reload the view.
- (void)loadTrends:(id)dataSource{
    [self prepareForLoading];
    
    if([dataSource isKindOfClass:[NSArray class]]){
            
        if([dataSource count]){
            NSDictionary *contentDict = [dataSource objectAtIndex:0];
            NSArray *trendArray = [contentDict objectForKey:@"trends"];
            for(NSDictionary *trendDict in trendArray){
                Trend *trend = [[Trend alloc] init];
                [trend setName:[trendDict objectForKey:@"name"]];
                [trend setQuery:[trendDict objectForKey:@"query"]];
                
                [self.dataArray addObject:trend];
            }
            [self.tableView reloadData];
        }
    }
}

// Calls the tweetRequestForSearchTerm on the singleton downloadqueue which is a subclass of NSOperationQueue.
// Also passes a block to execute when the download is complete.
// The view is refreshed in the main queue after download.
- (void)refreshFeed{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[DownloadQueue getDownloadQueue] tweetRequestForSearchTerm:self.searchTerm withHandler:^(id dataSource) {
        NSLog(@"Tweets downloaded");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadTweetsForTrend:dataSource];
        });
    }];
}

// Update the model from the results and reload the view.
-(void) loadTweetsForTrend:(id)dataSource{
    [self prepareForLoading];
    if([dataSource isKindOfClass:[NSDictionary class]]){
        NSDictionary *statusDict = [dataSource objectForKey:@"statuses"];
        
        for(NSDictionary *tweetDict in statusDict){
            Tweet *tweet = [[Tweet alloc] init];
            
            
            [tweet setPubDate:[tweetDict objectForKey:@"created_at"]];
            NSString *text = [tweetDict objectForKey:@"text"];
            [tweet setText:[text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSDictionary *userDict = [tweetDict objectForKey:@"user"];
            
            User *user = [[User alloc] init];
            [user setScreenName:[userDict objectForKey:@"screen_name"]];
            [user setProfileImageUrl:[userDict objectForKey:@"profile_image_url"]];
            [tweet setUser:user];
            
            [self.dataArray addObject:tweet];
        }
    }
    
    [self.tableView reloadData];
}

// stop the refresh control
// stop the network activity indicator displayed in the status bar
// if there is no datarray initialized do it, or remove all objects. we only show the latest 20 tweets and 10 trends
- (void)prepareForLoading{
    [self.refreshControl endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if(!dataArray)
        dataArray = [[NSMutableArray alloc] init];
    else
        [dataArray removeAllObjects];
}

// Utility method to calculate the height for different cells based on the content
- (CGFloat)getHeight:(Tweet*)feed{
    NSString *screenName = [[feed user] screenName];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:USER_NAME_FONT_SIZE];
    CGRect nameRect = [screenName boundingRectWithSize:CGSizeMake(MAX_WIDTH,MAX_HEIGHT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:boldFont}
                                               context:nil];
    
    
    NSString *textFeed = [feed text];
    UIFont *font = [UIFont systemFontOfSize:TWEET_FONT_SIZE];
    CGRect textRect = [textFeed boundingRectWithSize:CGSizeMake(MAX_WIDTH,MAX_HEIGHT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil];
    return nameRect.size.height + textRect .size.height+Y_OFFSET;
}

#pragma UITableView Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.pageType isEqualToString:@"Trends"]){
        return 40;
    }
    Tweet *feed = [self.dataArray objectAtIndex:indexPath.row];
    return [self getHeight:feed];
}

// Use the default UITableViewCell for Trends page
// USe FeedCell for The Tweets page
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.pageType isEqualToString:@"Trends"]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellIdentifier"];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        Trend *trend = [self.dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = trend.name;
        return cell;
    }
    else{
        FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
        if (cell == nil) {
            cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        Tweet *feed = [self.dataArray objectAtIndex:indexPath.row];
        [cell setUpContents:feed];
        
        return cell;
    }
    return nil;
}

#pragma -
#pragma TableView Delegate methods

// Upon click on Trends page load the corresponding Tweets page. Pass the query to be searched.
//If its a tweet page, do nothing.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.pageType isEqualToString:@"Tweets"]){
        return;
    }
    Trend *trend = (Trend*)[self.dataArray objectAtIndex:indexPath.row];
    FeedViewController *feedController = [[FeedViewController alloc] initForPage:@"Tweets" query:trend.query];
    [self.navigationController pushViewController:feedController animated:YES];
}

@end
