//
//  RelationshipPopoverViewController.h
//  iMobile Planner
//
//  Created by Meng Cheong on 7/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@protocol RelationshipPopoverViewControllerDelegate <NSObject>

@required
-(void)selectedRship:(NSString *)selectedRship;
@end


@interface RelationshipPopoverViewController : UITableViewController
{
    
        NSString *databasePath;
        sqlite3 *contactDB;
    

}

@property (nonatomic, strong) NSMutableArray *IDTypes;
@property (nonatomic, weak) id<RelationshipPopoverViewControllerDelegate> delegate;

@property(nonatomic, assign) int rowToUpdate;


@end
