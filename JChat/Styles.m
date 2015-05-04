//
//  Styles.m
//  JChat
//
//  Created by Aimee Amador on 12/30/13.
//  Copyright (c) 2013 JChat. All rights reserved.
//

#import "Styles.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation Styles

//round corner to style views
+(void) styleRoundCorneredView:(UIView *)view
{
    view.layer.cornerRadius = 25.f;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}

//styles
+ (void)applyStyle
{
    //Set Navigation bar BG Color
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xF09100)];
    
    //Set Navigation bar Text font and color
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue" size:21.0], NSFontAttributeName, nil]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    //Set Status Bar Light Color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}

@end
