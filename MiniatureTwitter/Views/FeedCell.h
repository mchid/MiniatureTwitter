//
//  FeedCell.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/10/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "UIImageView+AFNetworking.h"

@interface FeedCell : UITableViewCell

@property (nonatomic,strong) NSString *profileUrlString;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *feedNameLabel;
@property (nonatomic,strong) UILabel *feedTextLabel;

- (void)setUpContents:(Feed*)feed;
-(void)loadImage:(NSString*)profileUrlString;
-(void)loadImageFromCache:(NSString*)profileUrlString;


@end
