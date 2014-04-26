//
//  DownloadQueue.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "DownloadQueue.h"
#import "TweetDownloader.h"
#import "TrendDownloader.h"

@implementation DownloadQueue

static DownloadQueue  *_sharedDownloadQueue = nil;
static ACAccount *account = nil;

// Class method used to get the singleton instance.
// Any subsequent calls to this will not create new instance of the class.
// Set the max concurrent operation count to 3.
// The Twitter account configured on the device is verified here. If no account present a notification is raised which is handled in the appdelegate
// All these will never run more than once.
+(DownloadQueue*)getDownloadQueue
{
    @synchronized([DownloadQueue class])
    {
        if (!_sharedDownloadQueue){
            _sharedDownloadQueue = [[self alloc] init];
            [_sharedDownloadQueue setMaxConcurrentOperationCount:3];
            
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            ACAccountType *accountType = [accountStore
                                          accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            [accountStore requestAccessToAccountsWithType:accountType
                                                  options:nil completion:^(BOOL granted, NSError *error)
             {
                 NSString *result = @"failed";
                 if(granted){
                     NSArray *arrayOfAccounts = [accountStore
                                                 accountsWithAccountType:accountType];
                     
                     if ([arrayOfAccounts count] > 0){
                         account = [arrayOfAccounts lastObject];
                         result = @"success";
                     }
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSDictionary *userInfo = [NSDictionary dictionaryWithObject:result forKey:@"result"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountAuthenticationResponse" object:self userInfo:userInfo];
                 });
             }];
        }
        
        return _sharedDownloadQueue;
    }
    return nil;
}

// add the TweetDownloader operation to the queue
- (void)tweetRequestForSearchTerm:(NSString*)searchTerm withHandler:(void (^)(id dataSource))handler{
    if(account){
        TweetDownloader *tweetDownloader  = [[TweetDownloader alloc] initWithAccount:account search:searchTerm handler:handler];
        [_sharedDownloadQueue addOperation:tweetDownloader];
    }
}

// add the TrendDownloader operation to the queue
- (void)trendRequestWithCompletionHandler:(void (^)(id dataSource))handler{
    if(account){
        TrendDownloader *trendDownloader  = [[TrendDownloader alloc] initWithAccount:account handler:handler];
        [_sharedDownloadQueue addOperation:trendDownloader];
    }
}

@end
