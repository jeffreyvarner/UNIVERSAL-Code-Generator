//
//  VLCodeGenerationOperation.m
//  Universal
//
//  Created by Jeffrey Varner on 2/3/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLCodeGenerationOperation.h"

@interface VLCodeGenerationOperation ()

// private methods
-(void)cleanMyMemory;

// private properties -
@property (copy) MyVarnerlabCodeGenerationOperationBlock myOperationBlock;

@end

@implementation VLCodeGenerationOperation

// synthesize -
@synthesize myOperationBlock = _myOperationBlock;
@synthesize myOperationName = _myOperationName;

#pragma mark - main method
-(void)main
{
    // ok, so let's execute the block -
    MyVarnerlabCodeGenerationOperationBlock operationBlock = [self myOperationBlock];
    operationBlock();
}

-(void)setOperationBlock:(MyVarnerlabCodeGenerationOperationBlock)block
{
    // This should copy the block onto the heap -
    self.myOperationBlock = Block_copy(block);
}

-(void)releaseMyOperationBlock
{
    
}

-(void)dealloc
{
    NSLog(@"Dealloc called on %@",[[self class] description]);
    
    [self cleanMyMemory];
    [super dealloc];
}


#pragma mark - private lifecycle methods
-(void)cleanMyMemory
{
    Block_release([self myOperationBlock]);
    self.myOperationBlock = nil;
    self.myOperationName = nil;
}


@end
