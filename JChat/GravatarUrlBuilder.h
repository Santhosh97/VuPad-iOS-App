//
//  GravatarUrlBuilder.h
//  JChat
//
//  Created by Masaki Nakada on 11/11/13.
//  Copyright (c) 2013 Masaki Nakada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GravatarUrlBuilder : NSObject

+ (NSURL *)getGravatarUrl:(NSString *)email;

@end
