//
//  StatsViewController.m
//  MiniatureTwitter
//
//  Created by Muthu Chidambaram on 3/10/14.
//  Copyright (c) 2014 Muthu Chidambaram. All rights reserved.
//

#import "StatsViewController.h"
#import "Feed.h"

@interface StatsViewController ()

@end

@implementation StatsViewController
@synthesize feed;

- (id)initWithFeed:(Feed*)_feed
{
    self = [super init];
    if (self) {
        self.feed = _feed;
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Stats";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if(indexPath.row == 0){
        cell.textLabel.text = @"Screen Name :";
        [cell setAccessoryView:[self getAccessoryViewForString:[[feed user] screenName]]];
    }
    else   if(indexPath.row == 1){
        cell.textLabel.text = @"Location :";
        UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5,160,30)];
        [cell setAccessoryView:[self getAccessoryViewForString:[[feed user] location]]];
        [cell setAccessoryView:accessoryLabel];
    }
    else   if(indexPath.row == 2){
        cell.textLabel.text = @"Description :";
        [cell setAccessoryView:[self getAccessoryViewForString:[[feed user] description]]];
    }
    else   if(indexPath.row == 3){
        cell.textLabel.text = @"Followers Count :";
       [cell setAccessoryView:[self getAccessoryViewForInt:[[feed user] followersCount]]];
    }
    else   if(indexPath.row == 4){
        cell.textLabel.text = @"Friends Count :";
        [cell setAccessoryView:[self getAccessoryViewForInt:[[feed user] friendsCount]]];
    }
    else   if(indexPath.row == 5){
        cell.textLabel.text = @"Status Count :";
        [cell setAccessoryView:[self getAccessoryViewForInt:[[feed user] statusCount]]];
    }
    
    return cell;
}

- (UILabel*)getAccessoryViewForInt:(int)number{
    UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5,160,30)];
    [accessoryLabel setText:[NSString stringWithFormat:@"%d",number]];
     return  accessoryLabel;
}

- (UILabel*)getAccessoryViewForString:(NSString*)text{
    if(!text || [text isEqualToString:@""])
        text = @"---";
    UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5,160,30)];
    [accessoryLabel setText:text];
    return  accessoryLabel;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
