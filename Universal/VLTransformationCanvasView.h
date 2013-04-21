//
//  VLTransformationCanvasView.h
//  Universal
//
//  Created by Jeffrey Varner on 2/14/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class VLTransformationCanvasViewController;
@class VLTransformCanvasWidgetViewController;

@interface VLTransformationCanvasView : NSView
{
    @private
    VLTransformationCanvasViewController *_myViewController;
    NSView *_mySelectedWidgetView;
    
    BOOL _isDraggingWidget;
    NSPoint _myLastDragLocation;
    NSPoint _myCurrentLocation;
}

// properties -
@property (retain) IBOutlet VLTransformationCanvasViewController *myViewController;



@end
