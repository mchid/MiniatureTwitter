//
//  AppDelegate.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 4/21/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "DownloadQueue.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToAccountAuthenticationResult:) name:@"AccountAuthenticationResponse" object:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [DownloadQueue getDownloadQueue];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)respondToAccountAuthenticationResult:(NSNotification*)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSDictionary *userInfo = notification.userInfo;
    NSString *result = [userInfo objectForKey:@"result"];
    if([result isEqualToString:@"success"]){
        [self setupTabs];
    }
    else{
        [self showAlert:@"Please configure your twitter accounts from settings" title:@"No accounts found"];
    }
}

- (void)setupTabs{
    FeedViewController *feedController = [[FeedViewController alloc] initForPage:@"Trends" query:nil];
    UINavigationController *navFeedController = [[UINavigationController alloc] initWithRootViewController:feedController];
    [self.window setRootViewController:navFeedController];
}

- (void)showAlert:(NSString*)message title:(NSString*)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    });
}




@end
