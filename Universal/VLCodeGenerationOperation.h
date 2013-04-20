//
//  VLCodeGenerationOperation.h
//  Universal
//
//  Created by Jeffrey Varner on 2/3/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLCodeGenerationOperation : NSOperation
{
    @private
    MyVarnerlabCodeGenerationOperationBlock _myOperationBlock;
    NSString *_myOperationName;
}

// properties -
@property (retain) NSString *myOperationName;

// methods -
-(void)setOperationBlock:(MyVarnerlabCodeGenerationOperationBlock)block;
-(void)releaseMyOperationBlock;

@end
