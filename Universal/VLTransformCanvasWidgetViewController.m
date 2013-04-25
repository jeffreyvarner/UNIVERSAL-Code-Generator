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

// visual -
-(NSString *)getMyWidgetTitle;

// private props -
@property (retain) IBOutlet NSTextField *myTitleLabel;

@end

@implementation VLTransformCanvasWidgetViewController

// synthesize -
@synthesize myTitleLabel = _myTitleLabel;
@synthesize myDomainWidgetNode = _myDomainWidgetNode;

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
    
    // do we have the widget node?
    if ([self myDomainWidgetNode]!=nil)
    {
        NSString *title = [self getMyWidgetTitle];
        [[self myTitleLabel] setStringValue:title];
    }
}

-(void)dealloc
{
    [self cleanMyMemory];
    [super dealloc];
}

#pragma mark - callback methods
-(void)myTransformCanvasWidgetWasDoubleTapped
{
    // ok, so when this get's called, we want to launch the properties for this widget
    
    // post a notification w/the tree node
    NSNotification *myNotification = [NSNotification notificationWithName:VLUniversalTransformWidgetPropertiesWindowWasRequestedNotification
                                                                   object:[self myDomainWidgetNode]];
    [[NSNotificationCenter defaultCenter] postNotification:myNotification];
}

#pragma mark - title
-(NSString *)getMyWidgetTitle
{
    NSString *title = nil;
    
    // xpath -
    NSArray *titleArray = [[self myDomainWidgetNode] nodesForXPath:@"./listOfWidgetProperties/property[@name='WIDGET_LABEL_TEXT']/@value" error:nil];
    title = [[titleArray lastObject] stringValue];
    
    if (title==nil)
    {
        title = @"Title";
    }
    
    // return -
    return title;
}


#pragma mark - private lifecycle methods
-(void)setup
{
    
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    self.myTitleLabel = nil;
    self.myDomainWidgetNode = nil;
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
