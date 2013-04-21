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


@interface VLTransformationCanvasViewController : NSViewController
{
    @private
    NSMutableArray *_myIndexPathArray;
    NSMutableDictionary *_myWidgetCacheDictionary;
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

@end
