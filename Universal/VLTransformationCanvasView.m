//
//  VLTransformationCanvasView.m
//  Universal
//
//  Created by Jeffrey Varner on 2/14/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLTransformationCanvasView.h"
#import "VLTransformationCanvasViewController.h"
#import "VLTransformCanvasWidgetViewController.h"
#import "VLTransformationWrapper.h"

@interface VLTransformationCanvasView ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;

// private drawing methods
-(void)drawConnectionPathBetweenWidget:(VLTransformCanvasWidgetViewController *)widget_1
                             andWidget:(VLTransformCanvasWidgetViewController *)widget_2;

// private props -
@property (retain) NSView *mySelectedWidgetView;
@property (retain) NSMutableArray *myConnectionPathsArray;
@property (assign) VLTransformationCanvasViewState myCanvasState;

@end

@implementation VLTransformationCanvasView

// synthesize -
@synthesize myViewController = _myViewController;
@synthesize mySelectedWidgetView = _mySelectedWidgetView;
@synthesize myCanvasState = _myCanvasState;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // initialize -
        [self setup];
    }
    
    return self;
}

-(void)dealloc
{
    [self cleanMyMemory];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    if (self.myCanvasState == VLTransformationCanvasViewLinkState)
    {
        NSBezierPath* aPath = [NSBezierPath bezierPath];
        [aPath moveToPoint:_myInitialLinkLocation];
        [aPath lineToPoint:_myFinalLinkLocation];
        [aPath stroke];
    }
    else if (self.myCanvasState == VLTransformationCanvasViewNominalState)
    {
        // need to draw connection between widgets
        NSArray *connections = [[self myViewController] getCurrentListOfTransformations];
        for (VLTransformationWrapper *wrapper in connections)
        {
            // get vc's
            VLTransformCanvasWidgetViewController *firstViewController = [wrapper myFirstWidgetController];
            VLTransformCanvasWidgetViewController *secondViewController = [wrapper mySecondWidgetController];
            
            // draw path -
            [self drawConnectionPathBetweenWidget:firstViewController
                                        andWidget:secondViewController];
        }
    }
}

#pragma mark - private drawing methods
-(void)drawConnectionPathBetweenWidget:(VLTransformCanvasWidgetViewController *)widget_1
                             andWidget:(VLTransformCanvasWidgetViewController *)widget_2
{
    // get points -
    NSPoint point_1 = [[widget_1 view] frame].origin;
    NSPoint point_2 = [[widget_2 view] frame].origin;
    
    // ok, so we need to do some geometry -
    NSRect frame_1 = [[widget_1 view] frame];
    NSRect frame_2 = [[widget_2 view] frame];
    
    // in both cases, we need to move the y up
    CGFloat NEW_Y_W1 = point_1.y + (frame_1.size.height)/2;
    CGFloat NEW_Y_W2 = point_2.y + (frame_2.size.height)/2;
    
    // compute X -
    CGFloat NEW_X_W1 = 0.0f;
    CGFloat NEW_X_W2 = 0.0f;
    if (point_1.x<point_2.x)
    {
        NEW_X_W1 = point_1.x + frame_1.size.width;
        NEW_X_W2 = point_2.x;

    }
    else if (point_1.x > point_2.x)
    {
        NEW_X_W2 = point_2.x + frame_2.size.width;
        NEW_X_W1 = point_1.x;
    }
    else
    {
        NEW_X_W1 = point_1.x;
        NEW_X_W2 = point_2.x;
    }
    
    // Generate the new points -
    NSPoint new_point_1 = NSMakePoint(NEW_X_W1, NEW_Y_W1);
    NSPoint new_point_2 = NSMakePoint(NEW_X_W2, NEW_Y_W2);
    
    // stroke path between points -
    NSBezierPath* aPath = [NSBezierPath bezierPath];
    [aPath moveToPoint:new_point_1];
    [aPath lineToPoint:new_point_2];
    [aPath stroke];
}

#pragma mark - dragging destination protocal methods
- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender
{
    NSLog(@"Dragging entered method called...");
    
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    
    NSPasteboard *pboard;
    pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSStringPboardType]==YES)
    {
        // get the view controller -
        if ([self myViewController]!=nil)
        {
            [[self myViewController] addTransformationWidgetViewControllerToCanvas:sender];
        }
        
        // return -
        return YES;
    }
    
    // default -
    return NO;
}

#pragma mark - mouse handling events
-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(void)mouseDown:(NSEvent *)theEvent
{
    NSPoint clickLocation;
    BOOL itemHit = NO;
    
    // convert the click location into the view coords
    clickLocation = [self convertPoint:[theEvent locationInWindow]
                              fromView:nil];
    
    // did the click occur in the item?
    itemHit = [self isPointInItem:clickLocation];
    
    // Yes it did, note that we're starting to drag
    if (itemHit)
    {
        // ok, so we selected an item -
        // is this a control click?
        if ([theEvent modifierFlags] & NSControlKeyMask)
        {
            // ok, so we have a control click.
            // set the state flag -
            if ([self myCanvasState] == VLTransformationCanvasViewNominalState)
            {
                // ok, so we are moving from nominal to the link state
                self.myCanvasState = VLTransformationCanvasViewLinkState;
                
                // where is my click location?
                _myInitialLinkLocation = clickLocation;
            }
        }
        else
        {
            // flag the instance variable that indicates
            // a drag was actually started (w/no control mask)
            _isDraggingWidget = YES;
            
            // store the starting click location;
            _myLastDragLocation = clickLocation;
            
            // set the cursor to the closed hand cursor
            // for the duration of the drag
            [[NSCursor closedHandCursor] push];
        }
    }
}

-(void)mouseUp:(NSEvent *)theEvent
{
    
    // ok, so is this a control click -or- a regular click?
    if ([theEvent modifierFlags] & NSControlKeyMask &&
        self.myCanvasState == VLTransformationCanvasViewLinkState)
    {
        // ok, so we didn't make a love connection.
        self.myCanvasState = VLTransformationCanvasViewNominalState;
        
        // redraw (erase the line)
        [self setNeedsDisplay:YES];
    }
    else
    {
        // ok, we are done dragging
        _isDraggingWidget = NO;
        
        // finished dragging, restore the cursor
        [NSCursor pop];
        
        // the item has moved, we need to reset our cursor
        // rectangle
        [[self window] invalidateCursorRectsForView:self];
        
        // go back to original border -
        NSView *view = self.mySelectedWidgetView;
        
        // set the gray border -
        CGColorRef grey = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0);
        [[view layer] setBorderWidth:1.0f];
        [[view layer] setCornerRadius:5.0f];
        [[view layer] setBorderColor:grey];
        CGColorRelease(grey);
        
        // release the selected view -
        self.mySelectedWidgetView = nil;
    }
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    // get the new point -
    NSPoint newDragLocation=[self convertPoint:[theEvent locationInWindow]
                                      fromView:nil];
    
    // if we have a control click, we are drawing a line. Otherwise we are moving a widget
    if ([theEvent modifierFlags] & NSControlKeyMask &&
        self.myCanvasState == VLTransformationCanvasViewLinkState)
    {
        // grab the new point and redraw the view -
        _myFinalLinkLocation = newDragLocation;
        
        // r we over a widget?
        // change the color of the selected view?
        NSView *view = [[self myViewController] widgetForTransformationCanvas:self atPosition:newDragLocation];
        if (view!=nil)
        {
            self.mySelectedWidgetView = view;
            
            // set the gray border -
            CGColorRef grey = CGColorCreateGenericRGB(0.5, 0.5, 0.5, 0.3);
            [[view layer] setBorderWidth:1.0f];
            [[view layer] setCornerRadius:5.0f];
            [[view layer] setBorderColor:grey];
            CGColorRelease(grey);
            
            // ok, we have a hit. Build a connection?
            [[self myViewController] buildConnectionBetweenCanvasWidgetsAtInitialPoint:_myInitialLinkLocation
                                                                         andFinalPoint:_myFinalLinkLocation
                                                                          inCanvasView:self];
        }

        // ok, redraw me -
        [self setNeedsDisplay:YES];
    }
    else
    {
        if (_isDraggingWidget == YES)
        {
            
            // offset the pill by the change in mouse movement
            // in the event
            [self offsetLocationByX:(newDragLocation.x-_myLastDragLocation.x)
                               andY:(newDragLocation.y-_myLastDragLocation.y)];
            
            // save the new drag location for the next drag event
            _myLastDragLocation = newDragLocation;
            
            // set the origin on my selected view -
            NSRect myFrame = [[self mySelectedWidgetView] frame];
            myFrame.origin = _myLastDragLocation;
            [[self mySelectedWidgetView] setFrame:myFrame];
            
            // support automatic scrolling during a drag
            // by calling NSView's autoscroll: method
            [[self mySelectedWidgetView] autoscroll:theEvent];
            
            // update display (so we can re-draw any links)
            [self setNeedsDisplay:YES];
        }
    }
}

- (void)offsetLocationByX:(float)x andY:(float)y
{
    // tell the display to redraw the old rect
    [self setNeedsDisplayInRect:[self calculatedItemBounds]];
    
    // since the offset can be generated by both mouse moves
    // and moveUp:, moveDown:, etc.. actions, we'll invert
    // the deltaY amount based on if the view is flipped or
    // not.
    int invertDeltaY = [self isFlipped] ? -1: 1;
    
    _myCurrentLocation.x = _myCurrentLocation.x+x;
    _myCurrentLocation.y = _myCurrentLocation.y+y*invertDeltaY;
    
    // invalidate the new rect location so that it'll
    // be redrawn
    [self setNeedsDisplayInRect:[self calculatedItemBounds]];
}


// -----------------------------------
// Hit test the item
// -----------------------------------
- (BOOL)isPointInItem:(NSPoint)testPoint
{
    BOOL itemHit = NO;
    
    // grab the item -
    NSView *view = [[self myViewController] widgetForTransformationCanvas:self atPosition:testPoint];
    if (view!=nil)
    {
        itemHit = YES;
        self.mySelectedWidgetView = view;
        
        // set the gray border -
        CGColorRef grey = CGColorCreateGenericRGB(0.5, 0.5, 0.5, 0.3);
        [[view layer] setBorderWidth:1.0f];
        [[view layer] setCornerRadius:5.0f];
        [[view layer] setBorderColor:grey];
        CGColorRelease(grey);
    }
    
    return itemHit;
}

- (NSRect)calculatedItemBounds
{
    NSRect calculatedRect;
    
    // calculate the bounds of the draggable item
    // relative to the location
    calculatedRect.origin = _myCurrentLocation;
    
    // the example assumes that the width and height
    // are fixed values
    calculatedRect.size.width = 100.0f;
    calculatedRect.size.height = 100.0f;
    
    return calculatedRect;
}

#pragma mark - private lifecycle
-(void)setup
{
    // initially we are *not* dragging -
    _isDraggingWidget = NO;
    
    // we are initially nominal -
    self.myCanvasState = VLTransformationCanvasViewNominalState;
    
    // setup my paths array -
    if ([self myConnectionPathsArray] == nil)
    {
        self.myConnectionPathsArray = [NSMutableArray array];
    }
    
    // Register for drag -
    [self registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    self.myViewController = nil;
    self.mySelectedWidgetView = nil;
    self.myConnectionPathsArray = nil;
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
