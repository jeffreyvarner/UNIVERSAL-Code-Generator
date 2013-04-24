//
//  VLTransformationWrapper.h
//  Universal
//
//  Created by Jeffrey Varner on 4/24/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VLTransformCanvasWidgetViewController;

@interface VLTransformationWrapper : NSObject
{
    @private
    VLTransformCanvasWidgetViewController *_myFirstWidgetController;
    VLTransformCanvasWidgetViewController *_mySecondWidgetController;
}

// public properties -
@property (retain) VLTransformCanvasWidgetViewController *myFirstWidgetController;
@property (retain) VLTransformCanvasWidgetViewController *mySecondWidgetController;

// custom initializer -
-(id)initVLTransformationWrapperWithFirstWidgetController:(VLTransformCanvasWidgetViewController *)firstController
                                andSecondWidgetController:(VLTransformCanvasWidgetViewController *)secondController;

// do we already have a connection?
-(BOOL)doesContainController:(VLTransformCanvasWidgetViewController *)firstController
               andController:(VLTransformCanvasWidgetViewController *)secondController;

@end
