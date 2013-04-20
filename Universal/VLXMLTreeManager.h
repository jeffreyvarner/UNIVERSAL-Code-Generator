//
//  VLXMLTreeManager.h
//  Universal
//
//  Created by Jeffrey Varner on 2/16/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VLXMLTreeManager : NSObject
{
    @private
    NSMutableDictionary *_myWidgetTreeDictionary;
}

// methods
+(VLXMLTreeManager *)sharedManager;
+(void)shutdownSharedManager;

// methods to query trees in my collection
-(NSArray *)queryTree:(NSString *)treeKey withXPath:(NSString *)xpath;


@end
