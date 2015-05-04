//
//  SettingsViewController.h
//  JChat
//
//  Created by Aimee Amador on 1/17/14.
//  Copyright (c) 2014 JChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#include <stdlib.h>

@interface SettingsViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIView *photoContainerView;
@property (weak, nonatomic) IBOutlet UILabel *picPhotoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

- (IBAction)saveBtn:(id)sender;

- (IBAction)didTapPhoto:(id)sender;

@end
