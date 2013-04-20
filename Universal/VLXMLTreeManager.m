//
//  VLXMLTreeManager.m
//  Universal
//
//  Created by Jeffrey Varner on 2/16/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLXMLTreeManager.h"

@interface VLXMLTreeManager ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;

// private props -
@property (retain) NSMutableDictionary *myWidgetTreeDictionary;

@end

@implementation VLXMLTreeManager

// static instance returned when we get the shared instance -
static VLXMLTreeManager *_sharedInstance;

// synthesize -
@synthesize myWidgetTreeDictionary = _myWidgetTreeDictionary;


+(VLXMLTreeManager *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+(void)shutdownSharedManager;
{
    @synchronized(self)
    {
        // set the shared pointer to nil?
        [_sharedInstance release];
        _sharedInstance = nil;
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // initialize me ...
        [self setup];
    }
    
    // return self -
    return self;
}


-(void)dealloc
{
    [self cleanMyMemory];
    [super dealloc];
}

#pragma mark - tree query methods
-(NSArray *)queryTree:(NSString *)treeKey withXPath:(NSString *)xpath
{
    // get the tree -
    if ([[self myWidgetTreeDictionary] objectForKey:treeKey]!=nil)
    {
        NSXMLDocument *tree = [[self myWidgetTreeDictionary] objectForKey:treeKey];
        NSError *error = nil;
        NSArray *tmpArray = [tree nodesForXPath:xpath error:&error];
        if (error==nil)
        {
            return tmpArray;
        }
        else
        {
            // we should post this as a notification - so it get's picked up in the console
            NSLog(@"ERROR - xpath %@ gave error %@",xpath,[error description]);
            
            // return empty -
            return [NSArray array];
        }
    }
    
    // default is to return empty array -
    return [NSArray array];
}

#pragma mark - private lifecycle methods
-(void)setup
{
    // Register my notifications and gestures -
    if ([self myWidgetTreeDictionary]==nil)
    {
        // build the dictionary -
        self.myWidgetTreeDictionary = [NSMutableDictionary dictionary];
        
        // load the default widget tree -
        NSString *filePath = [[NSBundle mainBundle] pathForResource:DEFAULT_WIDGET_TREE_FILE ofType:@"xml"];
        NSData *myData = [NSData dataWithContentsOfFile:filePath];
        if (myData)
        {
            // load the tree -
            NSXMLDocument *myTree = [[NSXMLDocument alloc] initWithData:myData options:NSXMLDocumentTidyXML error:nil];
            
            // cache the tree -
            [[self myWidgetTreeDictionary] setObject:myTree forKey:kVLDefaultTransformationWidgetTree];
        }
    }
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    [[self myWidgetTreeDictionary] removeAllObjects];
    self.myWidgetTreeDictionary = nil;
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
