//
//  IDTypeViewController.h
//  iMobile Planner
//
//  Created by Erza on 6/5/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ModelIdentificationType.h"

@protocol IDTypeDelegate <NSObject>
@required
//- (void)selectedIDType:(NSString *)selectedIDType;
- (void)IDTypeDescSelected:(NSString *) IDTypeDesc;
- (void)IDTypeCodeSelected:(NSString *) IDTypeCode;
- (void)IDTypeCodeSelectedWithIdentifier:(NSString *) IDTypeCode Identifier:(NSString *)identifier;
@end

@interface IDTypeViewController : UITableViewController {
    ModelIdentificationType* modelIdentificationType;
	NSMutableArray *_IDTypeDesc;
    NSMutableArray *_IDTypeCode;
    NSString *databasePath;
    sqlite3 *contactDB;
    id<IDTypeDelegate> _delegate;
}
@property (nonatomic, strong) NSMutableArray *IDTypes;
@property (nonatomic, retain) NSMutableArray *IDTypeDesc;
@property (nonatomic, retain) NSMutableArray *IDTypeCode;
@property (nonatomic, retain) NSMutableArray *IDTypeIdentifier;
@property (nonatomic, strong) id<IDTypeDelegate> delegate;
@property (nonatomic, weak) id requestType;
@property (nonatomic, weak) id IDSelect;
@property(retain) NSIndexPath* lastIndexPath;

@end
