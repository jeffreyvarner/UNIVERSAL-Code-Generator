//
//  VLXMLTreeManager.m
//  Universal
//
//  Created by Jeffrey Varner on 2/16/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLXMLTreeManager.h"

@interface VLXMLTreeManager ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;

@end

@implementation VLXMLTreeManager

// static instance returned when we get the shared instance -
static VLXMLTreeManager *_sharedInstance;

+(VLXMLTreeManager *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+(void)shutdownSharedManager;
{
    @synchronized(self)
    {
        // set the shared pointer to nil?
        [_sharedInstance release];
        _sharedInstance = nil;
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // initialize me ...
        [self setup];
    }
    
    // return self -
    return self;
}


-(void)dealloc
{
    [self cleanMyMemory];
    [super dealloc];
}

#pragma mark - private lifecycle methods
-(void)setup
{
    // Register my notifications and gestures -
    
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
