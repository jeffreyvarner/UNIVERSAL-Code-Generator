//
//  VLCoreUtilitiesLib.h
//  Universal
//
//  Created by Jeffrey Varner on 2/14/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLCoreUtilitiesLib : NSObject
{
    
}

// View controller methods
+ (NSViewController *)getViewControllerForView:(NSView *)view;

// Generate a UUID -
+(NSString *)generateUUID;


@end
