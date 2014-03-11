//
//  FeedCell.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/10/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "FeedCell.h"
#import "Feed.h"

@implementation FeedCell
@synthesize imageView,feedNameLabel,feedTextLabel,profileUrlString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3,3,50,50)];
        [self addSubview:imageView];
        
        imageView.clipsToBounds = YES;
        CALayer *imageLayer = [imageView layer];
        [imageLayer setMasksToBounds:YES];
        [imageLayer setCornerRadius:10.0];
        
        
        self.feedNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,0,265,30)];
        [feedNameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [self addSubview:feedNameLabel];
        
        self.feedTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,30,265,100)];
        [feedTextLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:feedTextLabel];
    }
    return self;
}

- (void)setUpContents:(Feed*)feed{
    NSString *screenName = [[feed user] screenName];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:16.0];
    CGRect nameRect = [screenName boundingRectWithSize:CGSizeMake(260,100)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:boldFont}
                                         context:nil];
    CGRect sampleRect = [@"sample" boundingRectWithSize:CGSizeMake(260,100)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:boldFont}
                                                 context:nil];
    
    nameRect.origin = CGPointMake(60,3);
    [feedNameLabel setFrame:nameRect];
    [feedNameLabel setNumberOfLines:(nameRect.size.height/sampleRect.size.height)];
    [feedNameLabel setText:screenName];
    
    NSString *textFeed = [feed text];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGRect textRect = [textFeed boundingRectWithSize:CGSizeMake(260,1000)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil];
    CGRect sampleTextRect = [@"sample" boundingRectWithSize:CGSizeMake(260,1000)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil];
    textRect.origin = CGPointMake(60,nameRect.size.height);
    [feedTextLabel setFrame:textRect];
    [feedTextLabel setNumberOfLines:(textRect.size.height/sampleTextRect.size.height)];
    [feedTextLabel setText:textFeed];
    
    NSURL *url = [NSURL URLWithString:[[feed user] profileImageUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    [imageView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:nil failure:nil];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)loadImageFromCache:(NSString*)_avatarUrlString{
//    NSData *imageData = [[Global sharedGlobals] getImageFromCache:_avatarUrlString];
//    if(imageData){
//        [self imageDownloaded:imageData];
//    }
}

-(void)loadImage:(NSString*)_avatarUrlString {
//    NSData *imageData = [[ServerOperation sharedManager] downloadImage:_avatarUrlString delegate:self callBack:@selector(imageDownloaded:)];
//    if(imageData){
//        [self imageDownloaded:imageData];
//    }
}

-(void)imageDownloaded:(NSData*)imageData{
//    NSLog(@"Callback in PostCell after downloading image");
//    UIImage *avatar = [UIImage imageWithData:imageData];
//    [self.imageView setImage:avatar];
}
@end
