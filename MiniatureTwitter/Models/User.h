//
//  User.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/10/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{
    NSString *screenName;
    NSString *location;
    NSString *description;
    int followersCount;
    int friendsCount;
    int statusCount;
    NSString *profileImageUrl;
    BOOL following;
    BOOL followRequestSent;
}

@property (nonatomic,retain) NSString *screenName;
@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain) NSString *description;
@property (nonatomic) int followersCount;
@property (nonatomic) int friendsCount;
@property (nonatomic) int statusCount;
@property (nonatomic,retain) NSString *profileImageUrl;
@property (nonatomic) BOOL following;
@property (nonatomic) BOOL followRequestSent;


@end
