//
//  VLDatabaseManager.m
//  Universal
//
//  Created by Jeffrey Varner on 2/15/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLDatabaseManager.h"

@interface VLDatabaseManager ()

// private properties -
@property (retain) NSPersistentDocument *myDocument;

@end

@implementation VLDatabaseManager

// @synthesize statements -
@synthesize myDocument = _myDocument;

// static instance returned when we get the shared instance -
static VLDatabaseManager *_sharedInstance;

#pragma mark - lifecycle methods
// static accessor method -
+(VLDatabaseManager *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
        // ok - 
    
    }
    
    return self;
}

@end
