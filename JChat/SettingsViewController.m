//
//  SettingsViewController.m
//  JChat
//
//  Created by Aimee Amador on 1/17/14.
//  Copyright (c) 2014 JChat. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIImage+Thumbnail.h"
#import "Styles.h"

@interface SettingsViewController ()

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@end

@implementation SettingsViewController
@synthesize photoContainerView;
@synthesize picPhotoLabel;
@synthesize photoView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Display Profile Picture
    PFUser *user = [PFUser currentUser];
    
    PFFile *profilePic =  [user objectForKey:@"profilePic"];
    
    if(profilePic != nil)
    {
        if ([profilePic.url length] > 0) {
            [profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    photoView.image = image;
                }
                else{
                    photoView.image = [UIImage imageNamed:@"icon_person"];
                }
            }
             ];}
    }

 
}


-(IBAction)saveBtn:(id)sender {
    UIImage *img = self.photoView.image;
    
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if (img != nil) {
        
        
        fileData = UIImagePNGRepresentation(img);
        fileName = [[PFUser currentUser] username];
        fileName = [fileName stringByAppendingString:@".png"];
        fileType = @"image";
    }
   
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    PFUser *user = [PFUser currentUser];
    [user setObject:file forKey:@"profilePic"];
    
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {

            //NSLog(@"Error: %@ %@", error, [error userInfo]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー!"
                                                            message:@"もう一度お願いします" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];

            } else {
            
            //[self refresh:nil];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"完了"
                                                            message:@"プロフィール用のイメージの登録が完了しました！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            }
    }];
    
            /*
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:file forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //[self refresh:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
             */
}


- (IBAction)didTapPhoto:(id)sender {
    NSLog(@"Did Tap Photo!");
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"No camera detected!");
        [self pickPhoto];
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Photo",@"Pick from Photo Library", nil];
    [actionSheet showInView:self.view];
}

-(UIImagePickerController *) imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

-(void) takePhoto
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}

-(void) pickPhoto
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (self.imagePicker == nil) {
        NSLog(@"It's nil!");
    }
    else
    {
        NSLog(@"Not nil!");
    }
    
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    CGFloat side = 72.f;
    side *= [[UIScreen mainScreen] scale];
    
    UIImage *thumbnail = [image createThumbnailToFillSize:CGSizeMake(side, side)];
    self.photoView.image = thumbnail;
    //
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self pickPhoto];
            break;
    }
}


@end
