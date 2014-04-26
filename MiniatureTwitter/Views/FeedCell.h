//
//  FeedCell.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface FeedCell : UITableViewCell

@property (nonatomic,strong) UILabel *tweetUserNameLabel;
@property (nonatomic,strong) UILabel *tweetTextLabel;
@property (nonatomic) float height;

- (void)setUpContents:(Tweet*)tweet;


@end
