//
//  VLMyInputWidgetDataModel.h
//  Universal
//
//  Created by Jeffrey Varner on 2/13/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLMyInputWidgetDataModel : NSObject
{
    @private
    NSXMLElement *_myWidgetNode;
}

// public properties -
@property (retain) NSXMLElement *myWidgetNode;

// methods to get data for the widget prototype -
-(NSString *)getMyWidgetTitle;


@end
