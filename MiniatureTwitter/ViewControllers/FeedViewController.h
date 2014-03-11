//
//  FeedViewController.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/9/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *dataSource;
    UITableView *feedTableView;
}

@property (nonatomic,retain) NSArray *dataSource;

@end
