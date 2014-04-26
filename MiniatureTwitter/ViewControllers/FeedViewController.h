//
//  FeedViewController.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedViewController : UITableViewController<UITableViewDataSource>

- (id)initForPage:(NSString*)page query:(NSString*)query;

@end
