//
//  VLCoreUtilitiesLib.m
//  Universal
//
//  Created by Jeffrey Varner on 2/14/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLCoreUtilitiesLib.h"

@implementation VLCoreUtilitiesLib

#pragma mark - view controller methods
+ (NSViewController *)getViewControllerForView:(NSView *)view
{
    id nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[NSViewController class]])
    {
        return (NSViewController *)nextResponder;
    }
    else if ([nextResponder isKindOfClass:[NSView class]])
    {
        return [VLCoreUtilitiesLib getViewControllerForView:nextResponder];
    }
    else
    {
        return nil;
    }
}

+(NSString *)generateUUID
{
    // create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    // Get the snstring representation of the UUID
    NSString *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    
    // return (autoreleased) -
    return [uuidString autorelease];
}

@end
