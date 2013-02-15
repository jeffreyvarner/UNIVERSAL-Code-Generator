//
//  VLTransformCanvasWidgetViewController.m
//  Universal
//
//  Created by Jeffrey Varner on 2/14/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLTransformCanvasWidgetViewController.h"

@interface VLTransformCanvasWidgetViewController ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;

@end

@implementation VLTransformCanvasWidgetViewController

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

-(void)awakeFromNib
{
    // setup -
    [self setup];
    
    // set some border -
    [[[self view] layer] setBorderWidth:1.0f];
    [[[self view] layer] setBorderColor:[[NSColor blackColor] CGColor]];
    [[[self view] layer] setCornerRadius:5.0f];
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
