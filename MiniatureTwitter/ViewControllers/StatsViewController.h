//
//  StatsViewController.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/10/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface StatsViewController : UITableViewController<UITableViewDataSource, UITabBarDelegate>{
    Feed *feed;
}

@property (nonatomic,retain) Feed *feed;
- (id)initWithFeed:(Feed*)_feed;

@end
