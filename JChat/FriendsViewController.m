//
//  FriendsViewController.m
//  JChat
//
//  Created by Masaki Nakada on 11/11/13.
//  Copyright (c) 2013 Masaki Nakada. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditFriendsViewController.h"
#import "GravatarUrlBuilder.h"


@interface FriendsViewController ()

@end

@implementation FriendsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];

    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, error.userInfo);
        } else {
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
    //show no title when back arrow pointing to this controller is showed
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showEditFriends"]) {
        EditFriendsViewController *viewController = (EditFriendsViewController*)segue.destinationViewController;

        [viewController setFriends:[NSMutableArray arrayWithArray:self.friends]];
    }
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
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    /*
   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    
    dispatch_async(queue, ^{
        NSString *email = [user objectForKey:@"email"];
        NSURL *gravitarURL = [GravatarUrlBuilder getGravatarUrl:email];
        NSData *imageData = [NSData dataWithContentsOfURL:gravitarURL];
        
        if (imageData != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = [UIImage imageWithData:imageData];
                [cell setNeedsLayout];
            });
        }
        
    });
    */
    PFFile *profilePic =  [user objectForKey:@"profilePic"];
    
    if(profilePic){
    
        [profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                cell.imageView.image = image;
                [cell setNeedsLayout];
                //Make Cell Image Round
                cell.imageView.layer.masksToBounds = YES;
                cell.imageView.layer.cornerRadius = 22.0;
                cell.imageView.layer.borderWidth = 1.50;
                cell.imageView.layer.borderColor = [[UIColor whiteColor]CGColor];
                
            }else{
                cell.imageView.image = [UIImage imageNamed:@"icon_person"];
            }
        }];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"icon_person"];
    }

    cell.textLabel.font  = [UIFont fontWithName: @"STHeitiSC-Medium" size: 17.0];
    return cell;
}



@end
