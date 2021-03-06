//
//  VLTransformationCanvasViewController.h
//  Universal
//
//  Created by Jeffrey Varner on 2/14/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class VLTransformationCanvasView;
@class VLTransformCanvasWidgetViewController;
@class VLTransformationWrapper;

@interface VLTransformationCanvasViewController : NSViewController
{
    @private
    NSMutableArray *_myIndexPathArray;
    NSMutableDictionary *_myWidgetCacheDictionary;
    NSMutableArray *_myWidgetConnectionViewControllerArray;
}

// Factory method
+(NSViewController *)buildViewController;

// drag and drop methods
-(void)addTransformationWidgetViewControllerToCanvas:(id <NSDraggingInfo>)sender;
-(NSInteger)numberOfWidgetsOnCanvas;

// get widgets and widget controllers -
-(NSView *)widgetForTransformationCanvas:(VLTransformationCanvasView *)canvasView
                              atPosition:(NSPoint)point;
-(VLTransformCanvasWidgetViewController *)widgetControllerForTransformationCanvas:(VLTransformationCanvasView *)canvasView
                                                                       atPosition:(NSPoint)point;

-(void)buildConnectionBetweenCanvasWidgetsAtInitialPoint:(NSPoint)startPoint
                                           andFinalPoint:(NSPoint)finalPoint
                                            inCanvasView:(VLTransformationCanvasView *)view;

-(NSArray *)getCurrentListOfTransformations;

@end
