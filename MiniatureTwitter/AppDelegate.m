//
//  AppDelegate.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/7/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedViewController.h"
#import "SearchViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self authenticateToTwitterAccount];
    
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

- (void)authenticateToTwitterAccount {
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                      [self setupTabs];
                 });
             }
             else{
                 //TODO : move the strings to property file
                 [self showAlert:@"There are no twitter accounts configured. You can add or create a twitter account in settings." title:@"No Twitter Account"];
             }
         } else {
             [self showAlert:@"There are no twitter accounts configured. You can add or create a twitter account in settings." title:@"No Twitter Account"];
         }
     }];
}


- (void)setupTabs{
    FeedViewController *feedController = [[FeedViewController alloc] init];
    UINavigationController *navFeedController = [[UINavigationController alloc] initWithRootViewController:feedController];
    [navFeedController.tabBarItem setTitle:@"Feed"];
    
    SearchViewController *searchController = [[SearchViewController alloc] init];
    UINavigationController *navSearchController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [navSearchController.tabBarItem setTitle:@"Search"];
    
    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:[NSArray arrayWithObjects:navFeedController,navSearchController, nil] animated:YES];
    [self.window setRootViewController:tabController];
}

- (void)showAlert:(NSString*)message title:(NSString*)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    });
}




@end
