//
//  VLTransformationWidgetsPanelViewController.h
//  Universal
//
//  Created by Jeffrey Varner on 2/4/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class VLInputWidgetPrototypeViewController;
@class VLMyInputWidgetDataModel;

@interface VLTransformationWidgetsPanelViewController : NSViewController<NSCollectionViewDelegate>
{
    @private
    NSCollectionView *_myInputCollectionView;
    NSMutableArray *_myCollectionViewDataArray;
}

// Factory method
+(NSViewController *)buildViewController;


@end
