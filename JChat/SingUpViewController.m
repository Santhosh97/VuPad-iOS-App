//
//  SingUpViewController.m
//  JChat
//
//  Created by Masaki Nakada on 11/11/13.
//  Copyright (c) 2013 Masaki Nakada. All rights reserved.
//

#import "SingUpViewController.h"
#import <Parse/Parse.h>

@interface SingUpViewController ()

@end

@implementation SingUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (IBAction)signUp:(id)sender {
    NSString *username = [self.usernameField.text
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *password = [self.passwordField.text
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *email = [self.emailField.text
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"おっと!"
                                                            message:@"ユーザー名、パスワード、Eメールが正しいか確認をお願いします!"
                                                           delegate:Nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        PFUser *newUser = [PFUser user];
        [newUser setUsername:username];
        [newUser setPassword:password];
        [newUser setEmail:email];
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"おっと!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:Nil cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:[PFUser currentUser].objectId forKey:@"owner"];
            }
        }];
    }
    

}

- (IBAction)dismiss:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - UITextFieldDelegate


@end
