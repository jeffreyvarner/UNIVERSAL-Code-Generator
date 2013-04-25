//
//  VLWidgetPropertiesEditorWindowController.m
//  Universal
//
//  Created by Jeffrey Varner on 4/25/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLWidgetPropertiesEditorWindowController.h"

@interface VLWidgetPropertiesEditorWindowController ()

@end

@implementation VLWidgetPropertiesEditorWindowController

// Generic factory method -
+(NSWindowController *)buildWindowController
{
    
    // What is the nib name?
    NSString *tmpNibName = [[self class] description];
    
    // Build a controller -
    NSWindowController *tmpViewController = [[[[self class] alloc]
                                            initWithWindowNibName:tmpNibName] autorelease];
    
    // return -
    return tmpViewController;
}


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
