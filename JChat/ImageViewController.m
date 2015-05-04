//
//  ImageViewController.m
//  JChat
//
//  Created by Masaki Nakada on 11/11/13.
//  Copyright (c) 2013 Masaki Nakada. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    self.imageView.image = [UIImage imageWithData:imageData];
    
    NSString *senderName = [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"from %@", senderName];
    self.navigationItem.title  = title;
    //show no title when back arrow pointing to this controller is showen
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(timeOut)]) {
        NSNumber* duration = [self.message objectForKey:@"fileDuration"];
        NSInteger value = [duration integerValue];
        [NSTimer scheduledTimerWithTimeInterval:value target:self selector:@selector(timeOut) userInfo:Nil repeats:NO];
    }
}

#pragma mark - Helper methods

- (void)timeOut
    {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
