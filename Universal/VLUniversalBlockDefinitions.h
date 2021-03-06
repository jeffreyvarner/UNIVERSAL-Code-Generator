//
//  VLUniversalBlockDefinitions.h
//  Universal
//
//  Created by Jeffrey Varner on 4/20/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>


// define blocks -
typedef void (^MyVarnerlabCodeGenerationOperationBlock)(void);
typedef void (^MyVarnerlabCodeGenerationOperationCompletionBlock)(void);

// notifications -
FOUNDATION_EXPORT NSString *const VLUniversalTransformWidgetPropertiesWindowWasRequestedNotification;

// keys -
FOUNDATION_EXPORT NSString *const kVLDefaultTransformationWidgetTree;

// path/file constants -
FOUNDATION_EXPORT NSString *const DEFAULT_WIDGET_TREE_FILE;