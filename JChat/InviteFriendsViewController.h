//
//  InviteFriendsViewController.h
//  JChat
//
//  Created by Masaki Nakada on 11/11/13.
//  Copyright (c) 2013 Masaki Nakada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface InviteFriendsViewController : UITableViewController<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *contactList;
}

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (void)getAllContacts;


@end
