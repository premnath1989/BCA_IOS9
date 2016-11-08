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


// DECLARATION

@interface SPAJSubmittedList : UIViewController <UITableViewDelegate, UITableViewDataSource>

    // OBJECT

    @property (nonatomic, weak) QuerySPAJHeader *querySPAJHeader;
    @property (nonatomic, weak) UserInterface *functionUserInterface;
    @property (nonatomic, weak) Alert *functionAlert;

    // QUERY

    @property (nonatomic, weak) NSArray *arrayQuerySubmitted;

    // VARIABLE

    @property (nonatomic, weak) NSMutableArray *arrayTextField;
    @property (nonatomic, weak) NSNumber *intQueryID;
    @property (nonatomic, weak) NSString *stringQueryName;

    // TABLE

    @property (nonatomic, weak) IBOutlet UITableView *tableView;

    // LABEL

    @property (nonatomic, weak) IBOutlet UILabel *labelPageTitle;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldName;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldSPAJNumber;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldSocialNumber;

    @property (nonatomic, weak) IBOutlet UILabel *labelTablePolicyHolder;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableSPAJNumber;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableSubmittedDate;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableProduct;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableState;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableView;

    // TEXTFIELD

    @property (nonatomic, weak) IBOutlet UITextField *textFieldName;
    @property (nonatomic, weak) IBOutlet UITextField *textFieldSPAJNumber;
    @property (nonatomic, weak) IBOutlet UITextField *textFieldSocialNumber;

    // BUTTON

    @property (nonatomic, weak) IBOutlet UIButton *buttonSearch;
    @property (nonatomic, weak) IBOutlet UIButton *buttonReset;
    @property (nonatomic, weak) IBOutlet UIButton *buttonDelete;
    @property (nonatomic, weak) IBOutlet UIButton *buttonEdit;

    @property (nonatomic, weak) IBOutlet UIButton *buttonSortFullName;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortSPAJNumber;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortDateSumbit;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortProduct;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortStatus;
    
    // FUNCTION

    - (void) generateQuery;

@end