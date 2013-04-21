//
//  VLTransformationCanvasViewController.m
//  Universal
//
//  Created by Jeffrey Varner on 2/14/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLTransformationCanvasViewController.h"
#import "VLTransformationCanvasView.h"
#import "VLTransformCanvasWidgetViewController.h"

#define MAX_NUMBER_OF_WIDGETS 200

@interface VLTransformationCanvasViewController ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;

// methods associated with drag and drop -
-(void)setupDragAndDropBlockForTransformationView;

// factory methods for vwidgets -
-(NSView *)buildNewTransformationWidgetWithPayload:(NSString *)payload;

// properties -
@property (retain) NSMutableArray *myIndexPathArray;
@property (retain) NSMutableDictionary *myWidgetCacheDictionary;

@end

@implementation VLTransformationCanvasViewController

// synthesize -
@synthesize myIndexPathArray = _myIndexPathArray;
@synthesize myWidgetCacheDictionary = _myWidgetCacheDictionary;

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
    // call setup -
    [self setup];
    
    
}


-(void)dealloc
{
    [self cleanMyMemory];
    [super dealloc];
}

-(BOOL)acceptsFirstResponder
{
    return NO;
}

#pragma mark- data source methods
-(void)addTransformationWidgetViewControllerToCanvas:(id <NSDraggingInfo>)sender
{
    // get the paste board -
    NSPasteboard *pboard;
    pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSStringPboardType]==YES)
    {
        // Get data from pasteboard -
        NSString *payload = [pboard stringForType:NSStringPboardType];
        
        // build new widget -
        NSView *widget = [self buildNewTransformationWidgetWithPayload:payload];
        
        // place the widget -
        NSPoint origin = [sender draggingLocation];
        NSPoint converted_point = [[self view] convertPoint:origin fromView:nil];
        NSRect myFrame = NSMakeRect(converted_point.x,converted_point.y, 100.0f, 100.0f);
        [widget setFrame:myFrame];
        
        // add to the canvas -
        [[self view] addSubview:widget];
    }
}

-(NSInteger)numberOfWidgetsOnCanvas
{
    // get the cache, count the keys -
    NSDictionary *myCache = [self myWidgetCacheDictionary];
    return [[myCache allKeys] count];
}

#pragma mark - DnD methods
-(void)setupDragAndDropBlockForTransformationView
{
}

-(NSView *)buildNewTransformationWidgetWithPayload:(NSString *)payload
{
    // initialize -
    VLTransformCanvasWidgetViewController *widget = nil;
    
    // build -
    widget = (VLTransformCanvasWidgetViewController *)[VLTransformCanvasWidgetViewController buildViewController];
    
    // build the domain object -
    NSXMLElement *newXMLNode = [[[NSXMLElement alloc] initWithXMLString:payload error:nil] autorelease];
    [widget setMyDomainWidgetNode:newXMLNode];
    
    // cache the view controller -
    
    // Get the number of widgets we have on screen -
    NSInteger number_of_widgets = [self numberOfWidgetsOnCanvas];
    if (number_of_widgets>0)
    {
        // Draw an index path from the pool -
        NSIndexPath *myIndexPath = [[self myIndexPathArray] objectAtIndex:(number_of_widgets+1)];
        [[self myWidgetCacheDictionary] setObject:widget forKey:myIndexPath];
    }
    else
    {
        // Draw an index path from the pool -
        NSIndexPath *myIndexPath = [[self myIndexPathArray] objectAtIndex:0];
        [[self myWidgetCacheDictionary] setObject:widget forKey:myIndexPath];
    }
    
    // cast and return -
    NSView *view = [widget view];
    return view;
}

-(VLTransformCanvasWidgetViewController *)widgetControllerForTransformationCanvas:(VLTransformationCanvasView *)canvasView
                              atPosition:(NSPoint)point
{
    // initialize -
    __block VLTransformCanvasWidgetViewController *mySelectedWidgetController = nil;
    
    // ok, let's iterate through and do a hit test on the widgets we have on the
    // screen -
    NSDictionary *cache = [self myWidgetCacheDictionary];
    [cache enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                               VLTransformCanvasWidgetViewController *widgetController,
                                               BOOL *stop){
        
        // get the frame for the controller -
        NSRect myFrame = [[widgetController view] frame];
        if (NSPointInRect(point, myFrame))
        {
            // ok, so we found a hit -
            mySelectedWidgetController = widgetController;
            
            // stop -
            *stop = YES;
        }
    }];
    
    
    // return -
    return mySelectedWidgetController;
}


-(NSView *)widgetForTransformationCanvas:(VLTransformationCanvasView *)canvasView
                              atPosition:(NSPoint)point
{
    // initialize -
    NSView *myWidgetView = nil;
    __block VLTransformCanvasWidgetViewController *mySelectedWidgetController = nil;
    
    // ok, let's iterate through and do a hit test on the widgets we have on the
    // screen -
    NSDictionary *cache = [self myWidgetCacheDictionary];
    [cache enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                               VLTransformCanvasWidgetViewController *widgetController,
                                               BOOL *stop){
        
        // get the frame for the controller -
        NSRect myFrame = [[widgetController view] frame];
        if (NSPointInRect(point, myFrame))
        {
            // ok, so we found a hit -
            mySelectedWidgetController = widgetController;
            
            // stop -
            *stop = YES;
        }
    }];
    
    // get the view -
    myWidgetView = [mySelectedWidgetController view];
    
    // return -
    return myWidgetView;
}

#pragma mark - private lifecycle
-(void)setup
{
    // create pool of index path -
    if ([self myIndexPathArray]==nil)
    {
        self.myIndexPathArray = [NSMutableArray array];
        
        for (NSInteger index = 0;index<MAX_NUMBER_OF_WIDGETS;index++)
        {
            NSIndexPath *myIndexPath = [NSIndexPath indexPathWithIndex:index];
            [[self myIndexPathArray] addObject:myIndexPath];
        }
    }
    
    // create the cache -
    if ([self myWidgetCacheDictionary]==nil)
    {
        self.myWidgetCacheDictionary = [NSMutableDictionary dictionary];
    }
    
    // setup the drop block -
    [self setupDragAndDropBlockForTransformationView];
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
