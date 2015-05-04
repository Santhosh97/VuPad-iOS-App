//
//  RecUtilityToolbar.m
//  JChat
//
//  Created by Aimee Amador on 1/8/14.
//  Copyright (c) 2014 JChat. All rights reserved.
//

#import "RecUtilityToolbar.h"

@implementation RecUtilityToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [[UIImage imageNamed:@"toolBarBackground.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
