//
//  VLInputWidgetPrototypeViewController.m
//  Universal
//
//  Created by Jeffrey Varner on 2/13/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLInputWidgetPrototypeViewController.h"
#import "VLMyInputWidgetDataModel.h"

@interface VLInputWidgetPrototypeViewController ()

// private lifecycle methods
-(void)setup;
-(void)cleanMyMemory;


// private props -
@property (retain) NSEvent *myMouseDownEvent;
@property (retain) IBOutlet NSTextField *myWidgetTitleLabel;

@end

@implementation VLInputWidgetPrototypeViewController

// synthesize -
@synthesize myMouseDownEvent = _myMouseDownEvent;
@synthesize myToolWidgetContext = _myToolWidgetContext;
@synthesize myWidgetTitleLabel = _myWidgetTitleLabel;

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
    // setup me up ...
    [self setup];
    
    // set some border -
    [[[self view] layer] setBorderWidth:1.0f];
    [[[self view] layer] setBorderColor:[[NSColor blackColor] CGColor]];
    [[[self view] layer] setCornerRadius:5.0f];
    
    // set the title -
    if ([self representedObject]!=nil)
    {
        // populate my text -
        VLMyInputWidgetDataModel *dataModel = (VLMyInputWidgetDataModel *)[self representedObject];
        NSString *title_string = [dataModel getMyWidgetTitle];
        [[self myWidgetTitleLabel] setStringValue:title_string];
    }
}

#pragma mark - drag source protocal methods
- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    switch(context)
    {
        case NSDraggingContextWithinApplication:
            return NSDragOperationCopy;
            break;
        default:
            return NSDragOperationMove;
            break;
    }
}


#pragma mark - key events

-(void)keyDown:(NSEvent *)theEvent
{
    [super keyDown:theEvent];
}

#pragma mark - mouse touch event handling 
-(void)mouseDown:(NSEvent *)theEvent
{
    // Ok, so grab the mouse down event --
    self.myMouseDownEvent = theEvent;
    
    // Highlight -
    CGColorRef blue = CGColorCreateGenericRGB(0, 0, 1, 0.5);
    [[[self view] layer] setBorderColor:blue];
    [[[self view] layer] setBorderWidth:3.0f];
    [[[self view] layer] setBackgroundColor:[[NSColor blueColor] CGColor]];
    CGColorRelease(blue);
}



#pragma mark - private lifecycle methods
-(void)setup
{
    // Register my notifications and gestures -
    
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    self.myMouseDownEvent = nil;
    self.myWidgetTitleLabel = nil;
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
