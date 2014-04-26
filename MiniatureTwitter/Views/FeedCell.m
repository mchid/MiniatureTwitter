//
//  FeedCell.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "FeedCell.h"
#import "Tweet.h"

#define USER_NAME_FONT_SIZE 18.0
#define TWEET_FONT_SIZE 12.0
#define  X_OFFSET 5.0
#define Y_OFFSET 3.0
#define MAX_WIDTH 310
#define MAX_HEIGHT 1000

@implementation FeedCell
@synthesize tweetUserNameLabel, tweetTextLabel, height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.tweetUserNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [tweetUserNameLabel setFont:[UIFont boldSystemFontOfSize:USER_NAME_FONT_SIZE]];
        [self addSubview:tweetUserNameLabel];
        
        self.tweetTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [tweetTextLabel setFont:[UIFont systemFontOfSize:TWEET_FONT_SIZE]];
        [self addSubview:tweetTextLabel];
    }
    return self;
}

- (void)setUpContents:(Tweet*)tweet{
    NSString *screenName = [[tweet user] screenName];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:USER_NAME_FONT_SIZE];
    CGRect nameRect = [screenName boundingRectWithSize:CGSizeMake(MAX_WIDTH,1000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:boldFont}
                                         context:nil];
    CGRect sampleRect = [@"sample" boundingRectWithSize:CGSizeMake(MAX_WIDTH,MAX_HEIGHT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:boldFont}
                                                 context:nil];
    
    nameRect.origin = CGPointMake(X_OFFSET,Y_OFFSET);
    [tweetUserNameLabel setFrame:nameRect];
    [tweetUserNameLabel setNumberOfLines:(nameRect.size.height/sampleRect.size.height)];
    [tweetUserNameLabel setText:screenName];
    
    NSString *textFeed = [tweet text];
    UIFont *font = [UIFont systemFontOfSize:TWEET_FONT_SIZE];
    CGRect textRect = [textFeed boundingRectWithSize:CGSizeMake(MAX_WIDTH,MAX_HEIGHT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil];
    CGRect sampleTextRect = [@"sample" boundingRectWithSize:CGSizeMake(MAX_WIDTH,MAX_HEIGHT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil];
    textRect.origin = CGPointMake(X_OFFSET,nameRect.size.height+Y_OFFSET);
    [tweetTextLabel setFrame:textRect];
    [tweetTextLabel setNumberOfLines:(textRect.size.height/sampleTextRect.size.height)];
    [tweetTextLabel setText:textFeed];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}


@end
