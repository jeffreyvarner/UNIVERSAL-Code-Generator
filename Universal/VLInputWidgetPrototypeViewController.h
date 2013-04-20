//
//  VLInputWidgetPrototypeViewController.h
//  Universal
//
//  Created by Jeffrey Varner on 2/13/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    VLUniversalToolWidgetContextPalette,
    VLUniversalToolWidgetContextCanvas
} VLUniversalToolWidgetContext;

@class VLMyInputWidgetDataModel;

@interface VLInputWidgetPrototypeViewController : NSCollectionViewItem
{
    @private
    NSEvent *_myMouseDownEvent;
    VLUniversalToolWidgetContext _myToolWidgetContext;
    NSTextField *_myWidgetTitleLabel;
}

// properties -
@property (assign) VLUniversalToolWidgetContext myToolWidgetContext;

// Factory method
+(NSViewController *)buildViewController;

@end
