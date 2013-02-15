//
//  VLCodeGenerationEngine.m
//  Universal
//
//  Created by Jeffrey Varner on 2/3/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLCodeGenerationEngine.h"

@interface VLCodeGenerationEngine ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;

// private properties -
@property (retain) NSOperationQueue *myCodeTransformationProcessQueue;

@end

@implementation VLCodeGenerationEngine

// static instance returned when we get the shared instance -
static VLCodeGenerationEngine *_sharedInstance;

// synthesize -
@synthesize myCodeTransformationProcessQueue = _myCodeTransformationProcessQueue;
@synthesize myTransformationBlueprintTree = _myTransformationBlueprintTree;

// static accessor methods -
+(VLCodeGenerationEngine *)sharedTransformationEngine
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+(void)shutdownSharedEngine
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

#pragma mark - block operation methods
-(void)performCoupledOperationWithBlock:(MyVarnerlabCodeGenerationOperationBlock)operation
                             completion:(MyVarnerlabCodeGenerationOperationCompletionBlock)completion
                        myOperationName:(NSString *)myOperationName
                dependencyOperationName:(NSString *)operationName
{
    // Create a new operation to wrap the operation and completion block -
    VLCodeGenerationOperation *operationObject = [[VLCodeGenerationOperation alloc] init];
    
    // set the operation block -
    [operationObject setOperationBlock:operation];
    
    // set the completion block -
    [operationObject setCompletionBlock:completion];
    
    // Set *my name* -
    [operationObject setMyOperationName:myOperationName];
    
    // Ok, so before I can load the operation onto the queue, I need to set it's dependency
    // We are going to assume that the dependent operation is already on the queue -
    // Lookup based on the name of the operation
    NSArray *operationArray = [[self myCodeTransformationProcessQueue] operations];
    __block VLCodeGenerationOperation *masterOperationObject;
    [operationArray enumerateObjectsUsingBlock:^(VLCodeGenerationOperation *operation,NSUInteger index,BOOL *stop){
        
        // check names -
        NSString *local_operation_name = [operation myOperationName];
        NSLog(@"check local_name => %@ versus %@",local_operation_name,myOperationName);
        if ([local_operation_name isEqualToString:operationName]==YES)
        {
            masterOperationObject = operation;
            *stop = YES;
        }
    }];
    
    // Set the dependency -
    [operationObject addDependency:masterOperationObject];
    
    // ok, load the block onto the queue -
    [[self myCodeTransformationProcessQueue] addOperation:operationObject];
    
    // release the operation -
    [operationObject release];
}

-(void)performSingleOperationWithName:(NSString *)operationName
                                block:(MyVarnerlabCodeGenerationOperationBlock)operation
                           completion:(MyVarnerlabCodeGenerationOperationCompletionBlock)completion
{
    // Create a new operation to wrap the operation and completion block -
    VLCodeGenerationOperation *operationObject = [[VLCodeGenerationOperation alloc] init];
    
    // set the operation block -
    [operationObject setOperationBlock:operation];
    
    // set the completion block -
    [operationObject setCompletionBlock:completion];
    
    // Set ooperation name -
    [operationObject setMyOperationName:operationName];
    
    // ok, load the block onto the queue -
    [[self myCodeTransformationProcessQueue] addOperation:operationObject];
    
    // release the operation -
    [operationObject release];
    
}

-(void)performSingleOperationWithBlock:(MyVarnerlabCodeGenerationOperationBlock)operation
                            completion:(MyVarnerlabCodeGenerationOperationCompletionBlock)completion
{
    // Create a new operation to wrap the operation and completion block -
    VLCodeGenerationOperation *operationObject = [[VLCodeGenerationOperation alloc] init];
    
    // set the operation block -
    [operationObject setOperationBlock:operation];
    
    // set the completion block -
    [operationObject setCompletionBlock:completion];
    
    // ok, load the block onto the queue -
    [[self myCodeTransformationProcessQueue] addOperation:operationObject];
    
    // release the operation -
    [operationObject release];
}

#pragma mark - private lifecycle methods
-(void)setup
{
    
    // create the transformation queue -
    if ([self myCodeTransformationProcessQueue]==nil)
    {
        // Fire up a new process queue -
        self.myCodeTransformationProcessQueue = [[[NSOperationQueue alloc] init] autorelease];
        
        // Setup KVO so I can see when the queue has completed all operations
        [[self myCodeTransformationProcessQueue] addObserver:self
                                                  forKeyPath:@"operationCount"
                                                     options:0
                                                     context:nil];
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    
    if (object==self.myCodeTransformationProcessQueue &&
        [keyPath isEqualToString:@"operationCount"])
    {
        if ([[self myCodeTransformationProcessQueue] operationCount]==0)
        {
            // Fire all transformations are complete message -
            NSNotification *myNotification = [NSNotification notificationWithName:@"VLTransformationJobCompletedNotification"
                                                                           object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotification:myNotification];
        }
    }
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    self.myCodeTransformationProcessQueue = nil;
    self.myTransformationBlueprintTree = nil;
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
