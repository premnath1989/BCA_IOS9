//
//  User.h
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity SPAJ Header.h"
#import "Query SPAJ Header.h"


// DECLARATION

@interface InsertInitialization : NSObject

    // SPAJ HEADER

    @property (nonatomic, strong) QuerySPAJHeader* querySPAJHeader;

    - (void) initializeSPAJHeader;

@end