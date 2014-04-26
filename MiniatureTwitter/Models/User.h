//
//  User.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{
    NSString *screenName;
    NSString *profileImageUrl;
}

@property (nonatomic,retain) NSString *screenName;
@property (nonatomic,retain) NSString *profileImageUrl;

@end
