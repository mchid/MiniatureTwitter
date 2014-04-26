//
//  TweetDownloader.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "TweetDownloader.h"
#import <Social/Social.h>

@interface TweetDownloader(){
    void (^handle)(id);
}

@property (nonatomic,assign) NSString *searchTerm;
@property (nonatomic,assign) ACAccount *account;
@end


@implementation TweetDownloader
@synthesize searchTerm, account;

#pragma mark -

- (id)initWithAccount:(ACAccount*)acc search:(NSString*)search handler:(void (^)(id dataSource))handler{
    if (self = [super init]) {
        self.searchTerm = search;
        self.account = acc;
        handle = handler;
    }
    return self;
}

- (void)main {
    
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        [self refreshFeed];
    }
}

// The search query might contain some characters which might make our search url bad. Twitter might give you an error code 32.
// To avoid it, encode the query that you get from the network.
// TODO: Urls are hardoced. Should change to a property file.
- (void)refreshFeed{
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [self.searchTerm stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];

    
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=%@&count=10",encodedString];
    NSURL *requestURL = [NSURL URLWithString:urlString];
    
    SLRequest *postRequest = [SLRequest
                              requestForServiceType:SLServiceTypeTwitter
                              requestMethod:SLRequestMethodGET
                              URL:requestURL parameters:nil];
    
    postRequest.account = account;
    
    [postRequest performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse
       *urlResponse, NSError *error)
     {
         //NSLog(@"Response : %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
         id dataSource = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:NSJSONReadingMutableLeaves
                          error:&error];
         
         if (dataSource)
             handle(dataSource);
     }];
}

@end
