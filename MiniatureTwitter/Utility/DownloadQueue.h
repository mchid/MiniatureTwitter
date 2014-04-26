//
//  DownloadQueue.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadQueue : NSOperationQueue

+ (DownloadQueue*)getDownloadQueue;
- (void)tweetRequestForSearchTerm:(NSString*)searchTerm withHandler:(void (^)(id dataSource))handler;
- (void)trendRequestWithCompletionHandler:(void (^)(id dataSource))handler;

@end
