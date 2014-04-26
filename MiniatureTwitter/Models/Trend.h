//
//  Trend.h
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trend : NSObject{
    NSString *name;
    NSString *query;
}
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *query;

@end
