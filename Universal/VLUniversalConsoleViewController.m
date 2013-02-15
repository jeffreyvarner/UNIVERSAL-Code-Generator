//
//  VLUniversalConsoleViewController.m
//  Universal
//
//  Created by Jeffrey Varner on 2/13/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLUniversalConsoleViewController.h"

@interface VLUniversalConsoleViewController ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;


@end

@implementation VLUniversalConsoleViewController

// Generic factory method -
+(NSViewController *)buildViewController
{
    
    // What is the nib name?
    NSString *tmpNibName = [[self class] description];
    
    // Build a controller -
    NSViewController *tmpViewController = [[[[self class] alloc]
                                            initWithNibName:tmpNibName
                                            bundle:[NSBundle mainBundle]] autorelease];
    
    // return -
    return tmpViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
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
    
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
