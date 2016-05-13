//
//  RelationshipPopoverViewController.h
//  MPOS
//
//  Created by Meng Cheong on 7/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@protocol RelationshipPopoverViewControllerDelegate <NSObject>

@required
-(void)selectedRship:(NSString *)selectedRship :(NSString *)SelectedPshipCode;
@end


@interface RelationshipPopoverViewController : UITableViewController
{
    
        NSString *databasePath;
        sqlite3 *contactDB;
    

}
-(void)loadData:(NSNumber*)numberIsInternalStaff;
@property (nonatomic, strong) NSMutableArray *IDTypes, *IDCodes;

@property (nonatomic, weak) id<RelationshipPopoverViewControllerDelegate> delegate;

@property(nonatomic, assign) int rowToUpdate;


@end
