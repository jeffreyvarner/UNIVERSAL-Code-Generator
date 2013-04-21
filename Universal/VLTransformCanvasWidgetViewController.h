//
//  VLTransformCanvasWidgetViewController.h
//  Universal
//
//  Created by Jeffrey Varner on 2/14/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface VLTransformCanvasWidgetViewController : NSViewController
{
    @private
    NSTextField *_myTitleLabel;
    NSXMLElement *_myDomainWidgetNode;
}

// public -
@property (retain) NSXMLElement *myDomainWidgetNode;

// Factory method
+(NSViewController *)buildViewController;


@end
