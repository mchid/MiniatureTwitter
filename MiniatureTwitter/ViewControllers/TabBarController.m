//
//  TabViewController.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/9/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
     CGRect bounds = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:bounds];
   
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0,bounds.size.height-49,320,49)];
    [self.view addSubview:tabBar];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
