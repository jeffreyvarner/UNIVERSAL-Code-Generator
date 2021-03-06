//
//  VLTransformationWidgetsPanelViewController.m
//  Universal
//
//  Created by Jeffrey Varner on 2/4/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLTransformationWidgetsPanelViewController.h"
#import "VLInputWidgetPrototypeViewController.h"
#import "VLMyInputWidgetDataModel.h"

@interface VLTransformationWidgetsPanelViewController ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;

// private props -
@property (retain) IBOutlet NSCollectionView *myInputCollectionView;
@property (retain) NSMutableArray *myCollectionViewDataArray;

@end

@implementation VLTransformationWidgetsPanelViewController

// synthesize -
@synthesize myInputCollectionView = _myInputCollectionView;
@synthesize myCollectionViewDataArray = _myCollectionViewDataArray;

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
    [self setup];
}

-(void)dealloc
{
    [self cleanMyMemory];
    [super dealloc];
}


#pragma mark - collection view delegate methods
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



- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event
{
    return YES;
}

- (NSImage *)collectionView:(NSCollectionView *)collectionView draggingImageForItemsAtIndexes:(NSIndexSet *)indexes
                  withEvent:(NSEvent *)event
                     offset:(NSPointPointer)dragImageOffset
{
    NSString *tmpString = [[NSBundle mainBundle] pathForResource:@"Transmit-256" ofType:@"icns"];
    NSImage *myImage = [[[NSImage alloc] initWithContentsOfFile:tmpString] autorelease];
    return myImage;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id < NSDraggingInfo >)draggingInfo
                 index:(NSInteger)index
         dropOperation:(NSCollectionViewDropOperation)dropOperation
{
    return YES;
}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id < NSDraggingInfo >)draggingInfo
                    proposedIndex:(NSInteger *)proposedDropIndex
                    dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation
{
    return NSDragOperationEvery;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes
          toPasteboard:(NSPasteboard *)pasteboard
{
    
    [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType]  owner:self];
    
    // get the data -
    NSUInteger selected_index = indexes.firstIndex;
    NSXMLElement *node = [[[self myCollectionViewDataArray] objectAtIndex:selected_index] myWidgetNode];
    NSString *node_text = [node description];
    [pasteboard setString:node_text forType:NSStringPboardType];
    return YES;
}

#pragma mark - private lifecycle methods
-(void)setup
{
    // setup the dimension (number of items) of the collection view -
    [[self myInputCollectionView] setMaxNumberOfColumns:3];
    [[self myInputCollectionView] setMaxNumberOfRows:10];
    
    // Setup the prototype -
    VLInputWidgetPrototypeViewController *prototypeController = (VLInputWidgetPrototypeViewController *)[VLInputWidgetPrototypeViewController buildViewController];
    [[self myInputCollectionView] setItemPrototype:prototypeController];
    
    // we can select the items -
    [[self myInputCollectionView] setSelectable:YES];
    [[self myInputCollectionView] registerForDraggedTypes:@[NSPasteboardTypeString]];
    
    // build the content array -
    if ([self myCollectionViewDataArray]==nil)
    {
        // build empty array -
        self.myCollectionViewDataArray = [NSMutableArray array];
        
        // Get the default widgets -
        NSString *xpath = @".//listOfWidgets/Widget";
        NSArray *defaultWidgetsArray = [[VLXMLTreeManager sharedManager] queryTree:kVLDefaultTransformationWidgetTree withXPath:xpath];
        for (NSXMLElement *nodeElement in defaultWidgetsArray)
        {
            // build model - 
            VLMyInputWidgetDataModel *widget_model = [[VLMyInputWidgetDataModel alloc] init];
            
            // configure
            [widget_model setMyWidgetNode:nodeElement];
            
            // add -
            [[self myCollectionViewDataArray] addObject:widget_model];
            
            // release -
            [widget_model release];
        }
        
        // ok, add to this content to the collection -
        [[self myInputCollectionView] setContent:[self myCollectionViewDataArray]];
    }
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    self.myInputCollectionView = nil;
    self.myCollectionViewDataArray = nil;
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
