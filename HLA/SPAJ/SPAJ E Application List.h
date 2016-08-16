//
//  ViewController.h
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Query SPAJ Header.h"
#import "User Interface.h"
#import "Alert.h"

@protocol SPAJEappListDelegate

    - (IBAction)actionGoToExistingList:(id)sender;

@end

// DECLARATION

@interface SPAJEApplicationList : UIViewController <UITableViewDelegate, UITableViewDataSource>

    @property (nonatomic,strong) id <SPAJEappListDelegate> delegateSPAJEappList;

    // OBJECT

    @property (retain, strong) QuerySPAJHeader *querySPAJHeader;
    @property (retain, strong) UserInterface *functionUserInterface;
    @property (retain, strong) Alert *functionAlert;

    // QUERY

    @property (retain, strong) NSArray *arrayQueryEApplication;

    // VARIABLE

    @property (retain, strong) NSMutableArray *arrayTextField;
    @property (retain, strong) NSNumber *intQueryID;
    @property (retain, strong) NSString *stringQueryName;

    // TABLE

    @property (nonatomic, weak) IBOutlet UITableView *tableView;

    // LABEL

    @property (nonatomic, weak) IBOutlet UILabel *labelPageTitle;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldName;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldEApplicationNumber;

    @property (nonatomic, weak) IBOutlet UILabel *labelTablePolicyHolder;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableSPAJNumber;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableLastUpdateOn;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableEApp;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableState;

    // UIView

    @property (nonatomic, weak) IBOutlet UIView *viewTableHeader;

    // TEXTFIELD

    @property (nonatomic, weak) IBOutlet UITextField *textFieldName;
    @property (nonatomic, weak) IBOutlet UITextField *textFieldEApplicationNumber;

    // BUTTON

    @property (nonatomic, weak) IBOutlet UIButton *buttonSearch;
    @property (nonatomic, weak) IBOutlet UIButton *buttonReset;
    @property (nonatomic, weak) IBOutlet UIButton *buttonDelete;
    @property (nonatomic, weak) IBOutlet UIButton *buttonEdit;

    @property (nonatomic, weak) IBOutlet UIButton *buttonSortFullName;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortEappNumber;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortSPAJNumber;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortLastModified;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortStatus;
    

    // FUNCTION

    - (void) generateQuery;

@end