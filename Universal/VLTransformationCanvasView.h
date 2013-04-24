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
@class VLTransformationWrapper;

typedef enum {
    
    VLTransformationCanvasViewLinkState = 0,
    VLTransformationCanvasViewDraggingState = 1,
    VLTransformationCanvasViewNominalState = 2
    
} VLTransformationCanvasViewState;

@interface VLTransformationCanvasView : NSView
{
    @private
    VLTransformationCanvasViewController *_myViewController;
    
    NSView *_mySelectedWidgetView;
    NSMutableArray *_myConnectionPathsArray;
    
    
    BOOL _isDraggingWidget;
    NSPoint _myLastDragLocation;
    NSPoint _myInitialLinkLocation;
    NSPoint _myFinalLinkLocation;
    NSPoint _myCurrentLocation;
    
    // what state am I in?
    VLTransformationCanvasViewState _myCanvasState;
}

// properties -
@property (retain) IBOutlet VLTransformationCanvasViewController *myViewController;



@end
