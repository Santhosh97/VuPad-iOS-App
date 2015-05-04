//
//  InviteFriendsViewController.m
//  JChat
//
//  Created by Masaki Nakada on 11/11/13.
//  Copyright (c) 2013 Masaki Nakada. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "MSCellAccessory.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface InviteFriendsViewController () <UISearchDisplayDelegate>

@end

@implementation InviteFriendsViewController

UIColor *disclosureColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    disclosureColor = [UIColor orangeColor];
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.allUsers count]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getAllContacts];
    
    NSString *knownObject = @"name";
    NSArray *temp = [contactList valueForKey:knownObject];
    
    self.allUsers =temp;
    [self.tableView reloadData];
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
    NSString *user;
    
    
    
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
             NSString *item = [self.allUsers objectAtIndex:i];
            
            if ([item isEqualToString:cell.textLabel.text])
            {
                user = item;
            }
        }
    }
    else
    {
        user = [self.allUsers objectAtIndex:indexPath.row];
        cell.textLabel.text = user;
    }
    cell.textLabel.font  = [UIFont fontWithName: @"STHeitiSC-Medium" size: 17.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *user;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
        for (int i=0; i<self.allUsers.count; i++) {
            NSString *tempuser = [self.allUsers objectAtIndex:i];
            NSString *item = tempuser;
            
            if ([item isEqualToString:cell.textLabel.text])
            {
                user = tempuser;
            }
        }
    }
    else
    {
        user = [self.allUsers objectAtIndex:indexPath.row];
        cell.textLabel.text = user;
    }
    cell.textLabel.font  = [UIFont fontWithName: @"STHeitiSC-Medium" size: 17.0];
    [self sendInAppSMS:user];
    
    
}   
    
#pragma mark - frineds search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
    {
        [self.searchResults removeAllObjects];
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
        
        self.searchResults = [NSMutableArray arrayWithArray:[self.allUsers  filteredArrayUsingPredicate:resultPredicate]];
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
    
    
#pragma mark - address book method
    
    
- (void)getAllContacts{
    
    NSLog(@"Button Tapped!");
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }
    
}
    
    // Get the contacts.
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
	CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        BOOL bSaveContactList=true;
		NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
		ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
		//For username and surname
		ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
		
        CFStringRef firstName, lastName;
		firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
		lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        if(firstName!=NULL && lastName != NULL){
            [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        }else if(firstName==NULL && lastName != NULL){
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", lastName] forKey:@"name"];
        }else if(lastName==NULL && firstName != NULL){
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:@"name"];
        }else{
            bSaveContactList=false;
        }
		
		
		//For Email ids
		ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
		if(ABMultiValueGetCount(eMail) > 0) {
			[dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
		}
		
		//For Phone number
		NSString* mobileLabel;
        if(ABMultiValueGetCount(phones)<1)
        {
            bSaveContactList = false;
        }else{
        
            for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
                mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
                if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
                {
                    [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                }
                else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
                {
                    [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                    break ;
                }
            }
            
                
        }
        if (bSaveContactList) {
            [contactList addObject:dOfPerson];
        }
        
	}
    NSLog(@"Contacts = %@",contactList);
}
    
-(void) sendInAppSMS:(NSString*) user
    {
        NSString* phoneNumber;
        for (int i=0; i<self.allUsers.count; i++) {
            NSObject *tempuser = [contactList objectAtIndex:i];
            NSString *item = [tempuser valueForKey:@"name"];
            
            if ([item isEqualToString:user])
            {
                phoneNumber = [tempuser valueForKey:@"Phone"];
            }
        }
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = @"しぇあもやりましょう！テキストです。　ここからダウンロードできます♫ \n https://itunes.apple.com";
            controller.recipients = [NSArray arrayWithObjects:phoneNumber, nil];
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
    {
        switch (result) {
            case MessageComposeResultCancelled:
            {
                NSLog(@"Cancelled");
                break;
            }
            case MessageComposeResultFailed:
            {
                NSLog(@"cannot send a message");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"送信失敗!" message:@"ショートメッセージが送れないようです。別の方法で招待お願いします＞＜" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                break;
            }
            case MessageComposeResultSent:
                break;
            default:
                break;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }


@end
