//
//  VLDatabaseManager.h
//  Universal
//
//  Created by Jeffrey Varner on 2/15/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLDatabaseManager : NSObject
{
    @private
    NSPersistentDocument *_myDocument;
}

// Factory method (singleton accessor method)
+(VLDatabaseManager *)sharedManager;

@end
