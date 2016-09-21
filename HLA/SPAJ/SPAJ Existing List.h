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
#import "CameraViewController.h"

// DECLARATION

@interface SPAJExistingList : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    CameraViewController *imagePickerController;
    CGRect imagePickerRect;
}
    @property (strong, nonatomic) NSDictionary* dictTransaction;
    // OBJECT

    @property (strong, retain) QuerySPAJHeader *querySPAJHeader;
    @property (strong, retain) UserInterface *functionUserInterface;
    @property (strong, retain) Alert *functionAlert;

    // QUERY

    @property (strong, retain) NSArray *arrayQueryExisting;

    // VARIABLE

    @property (strong, retain) NSMutableArray *arrayTextField;
    @property (strong, retain) NSString *stringQueryName;
    @property (strong, retain) NSNumber *intQueryID;

    // LAYOUT

    @property (nonatomic, weak) IBOutlet UIStackView *stackViewNote;

    // TABLE

    @property (nonatomic, weak) IBOutlet UITableView *tableView;

    // LABEL

    @property (nonatomic, weak) IBOutlet UILabel *labelPageTitle;
    @property (nonatomic, weak) IBOutlet UILabel *labelNoteHeader;
    @property (nonatomic, weak) IBOutlet UILabel *labelNoteDetail;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldName;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldSPAJNumber;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldSocialNumber;

    @property (nonatomic, weak) IBOutlet UILabel *labelTablePolicyHolder;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableSPAJNumber;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableLastUpdateOn;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableSIVersion;
    @property (nonatomic, weak) IBOutlet UILabel *labelTableTimeRemaining;
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
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortLastModified;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortSIVersion;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSortTimeRemaining;

    // FUNCTION

    - (void) generateQuery;

@end