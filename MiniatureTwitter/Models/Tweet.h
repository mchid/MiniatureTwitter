//
//  Feed.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject{
    NSDate *pubDate;
    NSString *text;
    User *user;
}
@property (nonatomic,retain) NSDate *pubDate;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) User *user;


@end
