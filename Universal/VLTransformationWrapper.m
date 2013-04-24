//
//  VLTransformationWrapper.m
//  Universal
//
//  Created by Jeffrey Varner on 4/24/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLTransformationWrapper.h"

@interface VLTransformationWrapper ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;

// private props -



@end

@implementation VLTransformationWrapper

// synthesize -
@synthesize myFirstWidgetController = _myFirstWidgetController;
@synthesize mySecondWidgetController = _mySecondWidgetController;

-(id)initVLTransformationWrapperWithFirstWidgetController:(VLTransformCanvasWidgetViewController *)firstController
                                andSecondWidgetController:(VLTransformCanvasWidgetViewController *)secondController
{
    self = [super init];
    if (self) {
        
        // setup -
        [self setup];
        
        // grab my controllers -
        self.myFirstWidgetController = firstController;
        self.mySecondWidgetController = secondController;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)dealloc
{
    [self cleanMyMemory];
    [super dealloc];
}

#pragma mark - comparison method
-(BOOL)doesContainController:(VLTransformCanvasWidgetViewController *)firstController
               andController:(VLTransformCanvasWidgetViewController *)secondController
{
    BOOL rFlag = NO;
    
    if (firstController == [self myFirstWidgetController] &&
        secondController == [self mySecondWidgetController])
    {
        return YES;
    }
    
    // default is NO -
    return rFlag;
}

#pragma mark - private lifecycle methods
-(void)setup
{
    // Register my notifications and gestures -
    
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    self.mySecondWidgetController = nil;
    self.myFirstWidgetController = nil;
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
