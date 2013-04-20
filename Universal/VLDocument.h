//
//  VLDocument.h
//  Universal
//
//  Created by Jeffrey Varner on 2/1/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class VLTransformationWidgetsPanelViewController;
@class VLUniversalConsoleViewController;
@class VLTransformationCanvasViewController;

@interface VLDocument : NSPersistentDocument<NSSplitViewDelegate>
{
    @private
    NSSegmentedControl *_mySegmentedControl;
    NSSplitView *_myVerticalSplitView;
    NSSplitView *_myHorizontalSplitView;
    NSView *_myLeftPanelView;
    NSView *_myBottomPanelView;
    NSView *_myMainPanelView;
    NSWindow *_myWindow;
    
    // Left panel view controller -
    VLTransformationWidgetsPanelViewController *_myWidgetPanelViewController;
    VLUniversalConsoleViewController *_myConsolePanelViewController;
    VLTransformationCanvasViewController *_myTransformationCanvasViewController;
    
    // initialize -
    BOOL _didFinishInitializing;
}

// actions -
-(IBAction)myUniversalCodeGenerationButtonWasPushedAction:(NSButton *)button;



@end
