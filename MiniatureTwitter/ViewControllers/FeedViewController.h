//
//  FeedViewController.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/9/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *feedArray;
    UITableView *feedTableView;
}

@property (nonatomic,retain) NSMutableArray *feedArray;

@end
