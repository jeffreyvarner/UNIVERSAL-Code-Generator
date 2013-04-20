//
//  VLCodeGenerationEngine.h
//  Universal
//
//  Created by Jeffrey Varner on 2/3/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLCodeGenerationOperation.h"

@interface VLCodeGenerationEngine : NSObject
{
    @private
    NSOperationQueue *_myCodeTransformationProcessQueue;
    NSXMLDocument *_myTransformationBlueprintTree;
}

// properties -
@property (retain) NSXMLDocument *myTransformationBlueprintTree;


// methods
+(VLCodeGenerationEngine *)sharedTransformationEngine;
+(void)shutdownSharedEngine;

// perform operation methods
-(void)performSingleOperationWithBlock:(MyVarnerlabCodeGenerationOperationBlock)operation
                            completion:(MyVarnerlabCodeGenerationOperationCompletionBlock)completion;

-(void)performSingleOperationWithName:(NSString *)operationName
                                block:(MyVarnerlabCodeGenerationOperationBlock)operation
                           completion:(MyVarnerlabCodeGenerationOperationCompletionBlock)completion;

-(void)performCoupledOperationWithBlock:(MyVarnerlabCodeGenerationOperationBlock)operation
                             completion:(MyVarnerlabCodeGenerationOperationCompletionBlock)completion
                        myOperationName:(NSString *)myOperationName
                dependencyOperationName:(NSString *)operationName;


@end
