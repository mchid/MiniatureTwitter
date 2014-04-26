//
//  TrendDownloader.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "TrendDownloader.h"
#import <Social/Social.h>

@interface TrendDownloader(){
    void (^handle)(id);
}
@property (nonatomic,assign) ACAccount *account;
@end

@implementation TrendDownloader
@synthesize account;

- (id)initWithAccount:(ACAccount*)acc handler:(void (^)(id dataSource))handler{
    if (self = [super init]) {
        handle = handler;
        self.account = acc;
    }
    return self;
}

- (void)main {
    
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        [self getTrend];
    }
}

// TODO: Remove hardcoding of urls
// Twitter framework in ios sdk is used to talk to twitter
- (void)getTrend{
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/trends/place.json?id=2487956"];
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
         NSLog(@"Response : %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
         id dataSource = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:NSJSONReadingMutableLeaves
                          error:&error];
         
         if (dataSource)
             handle(dataSource);
     }];

}

@end
