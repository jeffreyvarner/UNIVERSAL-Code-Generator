//
//  VLMyInputWidgetDataModel.m
//  Universal
//
//  Created by Jeffrey Varner on 2/13/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLMyInputWidgetDataModel.h"

@interface VLMyInputWidgetDataModel ()

// Private lifecycle methods -
-(void)setup;
-(void)cleanMyMemory;


@end

@implementation VLMyInputWidgetDataModel

@synthesize myWidgetNode = _myWidgetNode;

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

#pragma mark - methods to get data 
-(NSString *)getMyWidgetTitle
{
    NSString *title = nil;
    
    // xpath -
    NSArray *titleArray = [[self myWidgetNode] nodesForXPath:@"./listOfWidgetProperties/property[@name='WIDGET_LABEL_TEXT']/@value" error:nil];
    title = [[titleArray lastObject] stringValue];
    
    return title;
}

#pragma mark - private lifecycle 
-(void)setup
{
    // Register my notifications and gestures -
    
}

-(void)cleanMyMemory
{
    // Clean my iVars -
    self.myWidgetNode = nil;
    
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
