//
//  TweetDownloader.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@interface TweetDownloader : NSOperation

- (id)initWithAccount:(ACAccount*)account search:(NSString*)search handler:(void (^)(id dataSource))handler;

@end
