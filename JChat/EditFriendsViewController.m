//
//  EditFriendsViewController.m
//  JChat
//
//  Created by Masaki Nakada on 11/11/13.
//  Copyright (c) 2013 Masaki Nakada. All rights reserved.
//

#import "EditFriendsViewController.h"
#import "MSCellAccessory.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface EditFriendsViewController () <UISearchDisplayDelegate>

@end

@implementation EditFriendsViewController

UIColor *disclosureColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser];
    disclosureColor = [UIColor orangeColor];
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.allUsers count]];
    //show no title when back arrow pointing to this controller is showen
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, error.userInfo);
        } else {
            self.allUsers = objects;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    else
    {
        return [self.allUsers count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *user;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
        for (int i=0; i<self.allUsers.count; i++) {
            PFUser *tempuser = [self.allUsers objectAtIndex:i];
            NSString *item = tempuser.username;
            
            if ([item isEqualToString:cell.textLabel.text])
            {
                user = tempuser;
            }
        }
    }
    else
    {
        user = [self.allUsers objectAtIndex:indexPath.row];
        cell.textLabel.text = user.username;
    }
    
    if ([self isFriend:user]) {
        //cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
        
        cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"checkbox_checked.png"]];
        [cell.accessoryView setFrame:CGRectMake(0, 0, 24, 24)];

    } else {
       // cell.accessoryView = nil;
        cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"checkbox_unchecked.png"]];
        [cell.accessoryView setFrame:CGRectMake(0, 0, 24, 24)];
    }
    
    UIFont *myFont = [ UIFont fontWithName: @"STHeitiSC-Medium" size: 17.0 ];
    cell.textLabel.font  = myFont;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PFUser *user;
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
        for (int i=0; i<self.allUsers.count; i++) {
            PFUser *tempuser = [self.allUsers objectAtIndex:i];
            NSString *item = tempuser.username;
            
            if ([item isEqualToString:cell.textLabel.text])
            {
                user = tempuser;
            }
        }
    }
    else
    {
        user = [self.allUsers objectAtIndex:indexPath.row];
        cell.textLabel.text = user.username;
    }
    
    PFRelation *friendsRelation = [self.currentUser relationforKey:@"friendsRelation"];
    
    if ([self isFriend:user]) {
        // Remove friend
        
        for (PFUser *friend in self.friends) {
            //cell.accessoryView = nil;
            cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"checkbox_unchecked.png"]];
            [cell.accessoryView setFrame:CGRectMake(0, 0, 24, 24)];

            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.friends removeObject:friend];
                break;
            }
        }
        [friendsRelation removeObject:user];
    } else {
        //cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
        cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"checkbox_checked.png"]];
        [cell.accessoryView setFrame:CGRectMake(0, 0, 24, 24)];
        [self.friends addObject:user];
        [friendsRelation addObject:user];
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, error.userInfo);
        }
    }];
    
    UIFont *myFont = [UIFont fontWithName: @"STHeitiSC-Medium" size: 17.0 ];
    cell.textLabel.font  = myFont;
}

#pragma mark - Helper methods

- (BOOL)isFriend:(PFUser *)user
{
    for (PFUser *friend in self.friends) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
}
    
    
    
#pragma mark - frineds search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
    {
        [self.searchResults removeAllObjects];
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
        
        NSMutableArray *tempUsersNameArray = [NSMutableArray arrayWithCapacity:[self.allUsers count]];
        for (int i=0; i<self.allUsers.count;i++){
            PFUser *user = [self.allUsers objectAtIndex:i];
            [tempUsersNameArray addObject:user.username];
        }
        self.searchResults = [NSMutableArray arrayWithArray:[tempUsersNameArray  filteredArrayUsingPredicate:resultPredicate]];
}
    
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
    {
        [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
        
        return YES; 
    }
 

    - (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
    {
        NSLog(@"WillEndSearch");
        [self.tableView reloadData];
    }
    
@end
