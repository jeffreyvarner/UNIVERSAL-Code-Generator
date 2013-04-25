//
//  VLTransformCanvasWidgetView.m
//  Universal
//
//  Created by Jeffrey Varner on 2/14/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLTransformCanvasWidgetView.h"
#import "VLTransformCanvasWidgetViewController.h"

@interface VLTransformCanvasWidgetView ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;

// private properties -
@property (retain) IBOutlet VLTransformCanvasWidgetViewController *myViewController;

@end

@implementation VLTransformCanvasWidgetView

// synthesize -
@synthesize myViewController = _myViewController;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // tracking area -
        NSTrackingArea *trackingArea = [[[NSTrackingArea alloc] initWithRect:frame
                                                                     options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow)
                                                                       owner:self
                                                                    userInfo:nil] autorelease];
        [self addTrackingArea:trackingArea];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

-(void)dealloc
{
    [self cleanMyMemory];
    [super dealloc];
}

-(BOOL)acceptsFirstResponder
{
    return YES;
}


-(void)viewDidMoveToWindow
{
    
}

#pragma mark - mouse event handling
-(void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    
    // ok, so we need to detect if this is a double click -
    NSInteger NUMBER_OF_CLICKS = [theEvent clickCount];
    if (NUMBER_OF_CLICKS == 2)
    {
        [[self myViewController] myTransformCanvasWidgetWasDoubleTapped];
    }
}

-(void)mouseUp:(NSEvent *)theEvent
{
    [super mouseUp:theEvent];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    [super mouseEntered:theEvent];
    
    // set the black border -
    CGColorRef black = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0);
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setCornerRadius:5.0f];
    [[self layer] setBorderColor:black];
    CGColorRelease(black);
    
    // set a light gray background -
    CGColorRef gray = CGColorCreateGenericRGB(0.95, 0.95, 0.95, 1.0);
    [[self layer] setBackgroundColor:gray];
    CGColorRelease(gray);
}

-(void)mouseExited:(NSEvent *)theEvent
{
    [super mouseExited:theEvent];
    
    // set the blue border -
    CGColorRef black = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0);
    [[self layer] setBorderWidth:1.0f];
    [[self layer] setCornerRadius:5.0f];
    [[self layer] setBorderColor:black];
    CGColorRelease(black);
    
    // set a light gray background -
    CGColorRef white = CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0);
    [[self layer] setBackgroundColor:white];
    CGColorRelease(white);
}

#pragma mark - private lifecycle
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
