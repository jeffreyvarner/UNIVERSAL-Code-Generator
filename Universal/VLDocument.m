//
//  VLDocument.m
//  Universal
//
//  Created by Jeffrey Varner on 2/1/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLDocument.h"
#import "VLTransformationWidgetsPanelViewController.h"
#import "VLUniversalConsoleViewController.h"
#import "VLTransformationCanvasViewController.h"
#import "VLWidgetPropertiesEditorWindowController.h"

// offset
#define LEFT_OFFSET 20.0f
#define RIGHT_OFFSET 20.0f
#define BOTTOM_OFFSET 20.0f
#define TOP_OFFSET 70.0f
#define WIDTH_LEFT_PANEL 300.0f
#define HEIGHT_BOTTOM_PANEL 600.0f

@interface VLDocument ()

// private properties -
@property (retain) IBOutlet NSSegmentedControl *mySegmentedControl;
@property (retain) IBOutlet NSSplitView *myVerticalSplitView;
@property (retain) IBOutlet NSSplitView *myHorizontalSplitView;
@property (retain) IBOutlet NSView *myLeftPanelView;
@property (retain) IBOutlet NSView *myBottomPanelView;
@property (retain) IBOutlet NSView *myMainPanelView;
@property (retain) NSWindow *myWindow;
@property (retain) VLTransformationWidgetsPanelViewController *myWidgetPanelViewController;
@property (retain) VLUniversalConsoleViewController *myConsolePanelViewController;
@property (retain) VLTransformationCanvasViewController *myTransformationCanvasViewController;
@property (retain) VLWidgetPropertiesEditorWindowController *myWidgetPropertiesWindowController;

// services -
-(void)setupMyServices;

// setup controls -
-(void)setupWindowSegmentControl;
-(IBAction)mySegmentedControlWasSelected:(NSSegmentedControl *)segmentedControl;

// private animation methods
-(void)buildAndDeployLeftPanelAnimation;
-(void)buildAndDeployBottomPanelAnimation;
-(void)restoreMainPanelRemoveLeftPanelAnimation;
-(void)restoreMainPanelRemoveBottomPanelAnimation;

// factory methods
-(NSView *)buildTransformationConsoleViewController;
-(NSView *)buildTransformationWidgetViewController;
-(NSView *)buildTransformationCanvasViewController;

// notifications
-(void)handleMyVLUniversalTransformWidgetPropertiesWindowWasRequestedNotification:(NSNotification *)notification;

// private lifecycle methods
-(void)setup;
-(void)cleanMyMemory;

@end

@implementation VLDocument

// synthesize -
@synthesize mySegmentedControl = _mySegmentedControl;
@synthesize myVerticalSplitView = _myVerticalSplitView;
@synthesize myWindow = _myWindow;
@synthesize myWidgetPanelViewController = _myWidgetPanelViewController;
@synthesize myConsolePanelViewController = _myConsolePanelViewController;
@synthesize myHorizontalSplitView = _myHorizontalSplitView;
@synthesize myBottomPanelView = _myBottomPanelView;
@synthesize myLeftPanelView = _myLeftPanelView;
@synthesize myMainPanelView = _myMainPanelView;
@synthesize myTransformationCanvasViewController = _myTransformationCanvasViewController;
@synthesize myWidgetPropertiesWindowController = _myWidgetPropertiesWindowController;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"VLDocument";
}

-(void)windowControllerWillLoadNib:(NSWindowController *)windowController
{
    // call to super -
    [super windowControllerWillLoadNib:windowController];
    
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
        
    // initialize -
    if (_didFinishInitializing == NO)
    {
        // wire up the segmented control -
        [self setupWindowSegmentControl];
        
        // setup the splitviews -
        [self setupSplitViews];
        
        // setup services -
        [self setupMyServices];
        
        // build the panel view controllers -
        NSView *widget_view = [self buildTransformationWidgetViewController];
        NSView *canvas_view = [self buildTransformationCanvasViewController];
        
        // add widget view to left view controller -
        [[self myLeftPanelView] addSubview:widget_view];
        
        // add canvas to screen -
        [[self myMainPanelView] addSubview:canvas_view];
        
        // ok, we are done -
        _didFinishInitializing = YES;
    }
}


+ (BOOL)autosavesInPlace
{
    return YES;
}

#pragma mark - actions
-(IBAction)myUniversalCodeGenerationButtonWasPushedAction:(NSButton *)button
{
    
}

#pragma mark - splitview delegate methods
- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
    // resize the widget panel -
    if ([self myWidgetPanelViewController]!=nil)
    {
        NSRect myFrame = [[self myLeftPanelView] frame];
        NSRect myWidgetFrame = NSMakeRect(0, 0, myFrame.size.width,myFrame.size.height);
        [[[[self myWidgetPanelViewController] view] layer] setBackgroundColor:[[NSColor whiteColor] CGColor]];
        [[[self myWidgetPanelViewController] view] setFrame:myWidgetFrame];
    }
    
    // resize the canvas panel -
    if ([self myTransformationCanvasViewController]!=nil)
    {
        NSRect myFrame = [[self myMainPanelView] frame];
        NSRect myCanvasFrame = NSMakeRect(0, 0, myFrame.size.width,myFrame.size.height);
        [[[[self myTransformationCanvasViewController] view] layer] setBackgroundColor:[[NSColor whiteColor] CGColor]];
        [[[self myTransformationCanvasViewController] view] setFrame:myCanvasFrame];
    }
}

#pragma mark - factory methods
-(NSView *)buildTransformationCanvasViewController
{
    // initialize -
    VLTransformationCanvasViewController *myViewController = nil;
    
    // build -
    myViewController = (VLTransformationCanvasViewController *)[VLTransformationCanvasViewController buildViewController];
    
    // configure -
    
    // How big is my window?
    NSWindow *myWindow = [[[self windowControllers] lastObject] window];
    NSRect myWindowFrame = [myWindow frame];
    
    NSRect myFrame = [[self myMainPanelView] frame];
    NSRect myWidgetFrame = NSMakeRect(0, 0, myFrame.size.width,myWindowFrame.size.height - BOTTOM_OFFSET - TOP_OFFSET);
    [[[myViewController view] layer] setBackgroundColor:[[NSColor whiteColor] CGColor]];
    [[myViewController view] setFrame:myWidgetFrame];
    
    // grab this instance -
    self.myTransformationCanvasViewController = myViewController;
    
    // get the view and return -
    NSView *view = [myViewController view];
    return view;
}

-(NSView *)buildTransformationWidgetViewController
{
    // initialize -
    VLTransformationWidgetsPanelViewController *myViewController = nil;
    
    // build -
    myViewController = (VLTransformationWidgetsPanelViewController *)[VLTransformationWidgetsPanelViewController buildViewController];
    
    // configure -
    
    // How big is my window?
    NSWindow *myWindow = [[[self windowControllers] lastObject] window];
    NSRect myWindowFrame = [myWindow frame];
    
    NSRect myFrame = [[self myLeftPanelView] frame];
    NSRect myWidgetFrame = NSMakeRect(0, 0, myFrame.size.width,myWindowFrame.size.height - BOTTOM_OFFSET - TOP_OFFSET);
    [[[myViewController view] layer] setBackgroundColor:[[NSColor whiteColor] CGColor]];
    [[myViewController view] setFrame:myWidgetFrame];
    
    // grab this instance -
    self.myWidgetPanelViewController = myViewController;
    
    // get the view and return -
    NSView *view = [myViewController view];
    return view;
}

-(NSView *)buildTransformationConsoleViewController
{
    // initialize -
    VLUniversalConsoleViewController *myViewController = nil;
    
    // build -
    myViewController = (VLUniversalConsoleViewController *)[VLUniversalConsoleViewController buildViewController];
    
    // configure -
    
    // set the frame -
    NSRect myFrame = [[self myBottomPanelView] frame];
    NSRect myBounds = NSMakeRect(0, 0, myFrame.size.width, myFrame.size.height);
    [[myViewController view] setBounds:myBounds];
    [[[myViewController view] layer] setBackgroundColor:[[NSColor blackColor] CGColor]];
    
    // grab this instance -
    self.myConsolePanelViewController = myViewController;
    
    // get the view and return -
    NSView *view = [myViewController view];
    return view;
}


#pragma mark - actions
-(IBAction)mySegmentedControlWasSelected:(NSSegmentedControl *)segmentedControl
{
    // How big is my window?
    NSWindow *myWindow = [[[self windowControllers] lastObject] window];
    NSRect myWindowFrame = [myWindow frame];

    // which index was tapped?
    NSInteger selected_index = [segmentedControl selectedSegment];
    if (selected_index == 0)
    {
        // OK, so r we selecting or unselecting?
        if ([segmentedControl isSelectedForSegment:selected_index]==YES)
        {
           [[self myVerticalSplitView] setPosition:WIDTH_LEFT_PANEL ofDividerAtIndex:0];
        }
        else
        {
            [[self myVerticalSplitView] setPosition:0.0f ofDividerAtIndex:0];
        }
    }
    else if (selected_index == 1)
    {
        // OK, so r we selecting or unselecting?
        if ([segmentedControl isSelectedForSegment:selected_index]==YES)
        {
            [[self myHorizontalSplitView] setPosition:HEIGHT_BOTTOM_PANEL ofDividerAtIndex:0];
        }
        else
        {
            [[self myHorizontalSplitView] setPosition:myWindowFrame.size.height ofDividerAtIndex:0];
        }
    }
    else if (selected_index == 2)
    {
        // OK, so r we selecting or unselecting?
        if ([segmentedControl isSelectedForSegment:selected_index]==YES)
        {
            
        }
        else
        {
            
        }
    }
}

#pragma mark - private animation methods
-(void)restoreMainPanelRemoveBottomPanelAnimation
{
    // what is the size of the screen?
    NSWindow *myWindow = [[[self windowControllers] lastObject] window];
    NSRect myWindowFrame = [myWindow frame];
    
    // What is my *current* scrollview frame?
    NSRect myCurrentScrollViewFrame = [[self myVerticalSplitView] frame];
    
    // resize the scrollview -
    NSRect myNewScrollViewFrame = NSMakeRect(myCurrentScrollViewFrame.origin.x,
                                             myCurrentScrollViewFrame.origin.y,
                                             myCurrentScrollViewFrame.size.width,
                                             myWindowFrame.size.height - TOP_OFFSET - BOTTOM_OFFSET);
    
    // what is the frame for the left panel -
    NSRect myNewConsolePanelInitialViewFrame = NSMakeRect(RIGHT_OFFSET,
                                                       -2*HEIGHT_BOTTOM_PANEL,
                                                       myWindowFrame.size.width - LEFT_OFFSET - RIGHT_OFFSET,
                                                       HEIGHT_BOTTOM_PANEL - BOTTOM_OFFSET);
    
    // build the blocks -
    void (^MyVarnerlabNSAnimationBlock)(NSAnimationContext *) = ^(NSAnimationContext *context){
        
        // set the animator on the scrollview -
        [[[self myVerticalSplitView] animator] setFrame:myNewScrollViewFrame];
        [[[[self myConsolePanelViewController] view] animator] setFrame:myNewConsolePanelInitialViewFrame];
    };
    
    void (^MyVarnerlabCompletionHandler)(void) = ^{
        
        // remove the pallette -
        [[[self myConsolePanelViewController] view] removeFromSuperview];
        self.myConsolePanelViewController = nil;
    };
    
    // execute the blocks -
    [NSAnimationContext runAnimationGroup:MyVarnerlabNSAnimationBlock
                        completionHandler:MyVarnerlabCompletionHandler];
}

-(void)buildAndDeployBottomPanelAnimation
{
    // what is the size of the screen?
    NSWindow *myWindow = [[[self windowControllers] lastObject] window];
    NSRect myWindowFrame = [myWindow frame];
    
    // What is my *current* scrollview frame?
    NSRect myCurrentScrollViewFrame = [[self myVerticalSplitView] frame];
    
    // resize the scrollview -
    NSRect myNewScrollViewFrame = NSMakeRect(myCurrentScrollViewFrame.origin.x,
                                             HEIGHT_BOTTOM_PANEL+BOTTOM_OFFSET,
                                             myCurrentScrollViewFrame.size.width,
                                             myWindowFrame.size.height - TOP_OFFSET - BOTTOM_OFFSET - HEIGHT_BOTTOM_PANEL);
    
    // what is the frame for the left panel -
    NSRect myNewBottomPanelInitialViewFrame = NSMakeRect(-2*WIDTH_LEFT_PANEL,
                                                       BOTTOM_OFFSET,
                                                       WIDTH_LEFT_PANEL,
                                                       myWindowFrame.size.height - TOP_OFFSET - BOTTOM_OFFSET);
    
    
    NSRect myNewBottomPanelFinalViewFrame = NSMakeRect(LEFT_OFFSET,
                                                     BOTTOM_OFFSET,
                                                     WIDTH_LEFT_PANEL - LEFT_OFFSET,
                                                     myWindowFrame.size.height - TOP_OFFSET - BOTTOM_OFFSET);
    
    // ok, so do we already a widgets controller?
    if ([self myConsolePanelViewController]==nil)
    {
        VLUniversalConsoleViewController *consolePanel = nil;
        if ([self myWidgetPanelViewController]==nil)
        {
            // Build a the widget panel view controller -
            consolePanel = (VLUniversalConsoleViewController *)[VLUniversalConsoleViewController buildViewController];
            
            // grab the widgets panel -
            self.myConsolePanelViewController = consolePanel;
        }
        else
        {
            consolePanel = [self myConsolePanelViewController];
        }
        
        // set the frame -
        [[consolePanel view] setFrame:myNewBottomPanelInitialViewFrame];
        
        // get the superview for the scrollview -
        NSView *parentView = [[self myVerticalSplitView] superview];
        
        // add the widgets panel to the screen -
        [parentView addSubview:[consolePanel view]];
    }
    
    
    
    // build the blocks -
    void (^MyVarnerlabNSAnimationBlock)(NSAnimationContext *) = ^(NSAnimationContext *context){
        
        // set the animator on the scrollview -
        [[[[self myConsolePanelViewController] view] animator] setFrame:myNewBottomPanelFinalViewFrame];
    };
    
    void (^MyVarnerlabCompletionHandler)(void) = ^{
        
        void (^SecondStage)(NSAnimationContext *) = ^(NSAnimationContext *context){
            
            [[[self myVerticalSplitView] animator] setFrame:myNewScrollViewFrame];
            
        };
        
        void (^DoneBlock)(void) = ^{
            
        };
        
        [NSAnimationContext runAnimationGroup:SecondStage
                            completionHandler:DoneBlock];
    };
    
    // execute the blocks -
    [NSAnimationContext runAnimationGroup:MyVarnerlabNSAnimationBlock
                        completionHandler:MyVarnerlabCompletionHandler];
}


-(void)buildAndDeployLeftPanelAnimation
{
    // what is the size of the screen?
    NSWindow *myWindow = [[[self windowControllers] lastObject] window];
    NSRect myWindowFrame = [myWindow frame];
    
    // resize the scrollview -
    NSRect myNewScrollViewFrame = NSMakeRect(WIDTH_LEFT_PANEL,
                                             BOTTOM_OFFSET,
                                             myWindowFrame.size.width - WIDTH_LEFT_PANEL - RIGHT_OFFSET,
                                             myWindowFrame.size.height - TOP_OFFSET - BOTTOM_OFFSET);
    
    // what is the frame for the left panel -
    NSRect myNewLeftPanelInitialViewFrame = NSMakeRect(-2*WIDTH_LEFT_PANEL,
                                             BOTTOM_OFFSET,
                                             WIDTH_LEFT_PANEL,
                                             myWindowFrame.size.height - TOP_OFFSET - BOTTOM_OFFSET);
    
    
    NSRect myNewLeftPanelFinalViewFrame = NSMakeRect(LEFT_OFFSET,
                                                     BOTTOM_OFFSET,
                                                     WIDTH_LEFT_PANEL - LEFT_OFFSET,
                                                     myWindowFrame.size.height - TOP_OFFSET - BOTTOM_OFFSET);
    
    // ok, so do we already a widgets controller?
    if ([self myWidgetPanelViewController]==nil)
    {
        VLTransformationWidgetsPanelViewController *widgetsPanel = nil;
        if ([self myWidgetPanelViewController]==nil)
        {
            // Build a the widget panel view controller -
            widgetsPanel = (VLTransformationWidgetsPanelViewController *)[VLTransformationWidgetsPanelViewController buildViewController];
            
            // grab the widgets panel -
            self.myWidgetPanelViewController = widgetsPanel;
        }
        else
        {
            widgetsPanel = [self myWidgetPanelViewController];
        }
        
        // set the frame -
        [[widgetsPanel view] setFrame:myNewLeftPanelInitialViewFrame];
        
        // get the superview for the scrollview -
        NSView *parentView = [[self myVerticalSplitView] superview];
        
        // add the widgets panel to the screen -
        [parentView addSubview:[widgetsPanel view]];
    }

    
    
    // build the blocks -
    void (^MyVarnerlabNSAnimationBlock)(NSAnimationContext *) = ^(NSAnimationContext *context){
        
        // set the animator on the scrollview -
        [[[[self myWidgetPanelViewController] view] animator] setFrame:myNewLeftPanelFinalViewFrame];
    };
    
    void (^MyVarnerlabCompletionHandler)(void) = ^{
      
        void (^SecondStage)(NSAnimationContext *) = ^(NSAnimationContext *context){
            
            [[[self myVerticalSplitView] animator] setFrame:myNewScrollViewFrame];
            
        };
        
        void (^DoneBlock)(void) = ^{
            
        };
        
        [NSAnimationContext runAnimationGroup:SecondStage
                            completionHandler:DoneBlock];
    };
    
    // execute the blocks -
    [NSAnimationContext runAnimationGroup:MyVarnerlabNSAnimationBlock
                        completionHandler:MyVarnerlabCompletionHandler];
}

-(void)restoreMainPanelRemoveLeftPanelAnimation
{
    // what is the size of the screen?
    NSWindow *myWindow = [[[self windowControllers] lastObject] window];
    NSRect myWindowFrame = [myWindow frame];
    
    // resize the scrollview -
    NSRect myNewScrollViewFrame = NSMakeRect(LEFT_OFFSET,
                                             BOTTOM_OFFSET,
                                             myWindowFrame.size.width - LEFT_OFFSET - RIGHT_OFFSET,
                                             myWindowFrame.size.height - TOP_OFFSET - BOTTOM_OFFSET);
    
    // what is the frame for the left panel -
    NSRect myNewLeftPanelInitialViewFrame = NSMakeRect(-2*WIDTH_LEFT_PANEL,
                                                       BOTTOM_OFFSET,
                                                       WIDTH_LEFT_PANEL,
                                                       myWindowFrame.size.height - TOP_OFFSET - BOTTOM_OFFSET);
    
    // build the blocks -
    void (^MyVarnerlabNSAnimationBlock)(NSAnimationContext *) = ^(NSAnimationContext *context){
        
        // set the animator on the scrollview -
        [[[self myVerticalSplitView] animator] setFrame:myNewScrollViewFrame];
        [[[[self myWidgetPanelViewController] view] animator] setFrame:myNewLeftPanelInitialViewFrame];
    };
    
    void (^MyVarnerlabCompletionHandler)(void) = ^{
        
        // remove the pallette -
        [[[self myWidgetPanelViewController] view] removeFromSuperview];
        self.myWidgetPanelViewController = nil;
    };
    
    // execute the blocks -
    [NSAnimationContext runAnimationGroup:MyVarnerlabNSAnimationBlock
                        completionHandler:MyVarnerlabCompletionHandler];

}

#pragma mark - notifications
-(void)handleMyVLUniversalTransformWidgetPropertiesWindowWasRequestedNotification:(NSNotification *)notification
{
    
    if ([self myWidgetPropertiesWindowController] == nil)
    {
        // Fire up the palette window controller -
        VLWidgetPropertiesEditorWindowController *controller = (VLWidgetPropertiesEditorWindowController *)[VLWidgetPropertiesEditorWindowController buildWindowController];
        
        // add myself as the delegate -
        [[controller window] setDelegate:self];
        
        // Add this to the main window?
        [self addWindowController:controller];
        
        // Fire up the window -
        NSWindow *tmpMyPaletteWindow = [controller window];
        [tmpMyPaletteWindow makeKeyAndOrderFront:self];
        
        // grab the controller -
        self.myWidgetPropertiesWindowController = controller;
        
        // release the controller -
        [controller release];
    }
}

#pragma mark - window delegate methods
- (void)windowWillClose:(NSNotification *)notification
{
    // remove me as a delegate from the window -
    //[[[self myWidgetPropertiesWindowController] window] setDelegate:nil];
    
    // Kill the palette window controller -
    self.myWidgetPropertiesWindowController = nil;
}

#pragma mark - services
-(void)setupMyServices
{
    // build the tree manager -
    [VLXMLTreeManager sharedManager];
    
    // ok, so we want to listen for a few notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMyVLUniversalTransformWidgetPropertiesWindowWasRequestedNotification:)
                                                 name:VLUniversalTransformWidgetPropertiesWindowWasRequestedNotification
                                               object:nil];
}

#pragma mark - setup controls
-(void)setupWindowSegmentControl
{
    // ok, setup the segment control
    if ([self mySegmentedControl]!=nil)
    {
        // Set the label -
        [[self mySegmentedControl] setLabel:@"Left" forSegment:0];
        [[self mySegmentedControl] setLabel:@"Center" forSegment:1];
        [[self mySegmentedControl] setLabel:@"Right" forSegment:2];
        
        // setup target action -
        [[self mySegmentedControl] setTarget:self];
        [[self mySegmentedControl] setAction:@selector(mySegmentedControlWasSelected:)];
    }
}

-(void)setupSplitViews
{
    // setup the split view -
    [[[self myVerticalSplitView] layer] setBorderWidth:1.0f];
    [[[self myVerticalSplitView] layer] setBorderColor:[[NSColor lightGrayColor] CGColor]];
}

#pragma mark - window launch methods
-(void)awakeFromNib
{
    // set me up -
    [self setup];
}


-(void)dealloc
{
    [self cleanMyMemory];
    [super dealloc];
}

#pragma mark - private lifecycle methods
-(void)setup
{
    // ok, initially we have *not* initialized -
    _didFinishInitializing = NO;
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    self.mySegmentedControl = nil;
    self.myVerticalSplitView = nil;
    self.myHorizontalSplitView = nil;
    self.myWindow = nil;
    self.myWidgetPanelViewController = nil;
    self.myMainPanelView = nil;
    self.myLeftPanelView = nil;
    self.myBottomPanelView = nil;
    self.myTransformationCanvasViewController = nil;
    self.myWidgetPropertiesWindowController = nil;
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
