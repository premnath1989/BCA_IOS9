//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Submitted List.h"
#import "Query SPAJ Header.h"
#import "SPAJ Submitted List Cell.h"
#import "String.h"


// DECLARATION

@interface SPAJSubmittedList ()



@end


// IMPLEMENTATION

@implementation SPAJSubmittedList

    // SYNTHESIZE

    @synthesize querySPAJHeader = _querySPAJHeader;
    @synthesize arrayQuerySubmitted = _arrayQuerySubmitted;
    @synthesize functionUserInterface = _functionUserInterface;
    @synthesize arrayTextField = _arrayTextField;
    @synthesize intQueryID = _intQueryID;
    @synthesize stringQueryName = _stringQueryName;
    @synthesize functionAlert = _functionAlert;


    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // INITIALIZATION
        
        _querySPAJHeader = [[QuerySPAJHeader alloc] init];
        _functionUserInterface = [[UserInterface alloc] init];
        _functionAlert = [[Alert alloc] init];
        
        
        // LAYOUT SETTING
        
        _arrayTextField = [[NSMutableArray alloc] init];
        [_arrayTextField addObject:_textFieldName];
        [_arrayTextField addObject:_textFieldSocialNumber];
        [_arrayTextField addObject:_textFieldSPAJNumber];
        
        [_tableView.delegate self];
        [_tableView.dataSource self];
        
        
        // DEFAULT QUERY
        
        [self generateQuery];
        
        
        // LOCALIZATION
        
        _labelPageTitle.text = NSLocalizedString(@"TITLE_SPAJSUBMITTEDLIST", nil);
        
        _labelFieldName.text = NSLocalizedString(@"FIELD_NAME", nil);
        _labelFieldSPAJNumber.text = NSLocalizedString(@"FIELD_SPAJNUMBER", nil);
        _labelFieldSocialNumber.text = NSLocalizedString(@"FIELD_SOCIALNUMBER", nil);
        
        _labelTablePolicyHolder.text = NSLocalizedString(@"TABLE_HEADER_POLICYHOLDER", nil);
        _labelTableSPAJNumber.text = NSLocalizedString(@"TABLE_HEADER_SPAJNUMBER", nil);
        _labelTableSubmittedDate.text = NSLocalizedString(@"TABLE_HEADER_SUBMITTEDDATE", nil);
        _labelTableProduct.text = NSLocalizedString(@"TABLE_HEADER_PRODUCT", nil);
        _labelTableState.text = NSLocalizedString(@"TABLE_HEADER_STATUS", nil);
        _labelTableView.text = NSLocalizedString(@"TABLE_HEADER_VIEW", nil);
        
        [_buttonSearch setTitle:NSLocalizedString(@"BUTTON_SEARCH", nil) forState:UIControlStateNormal];
        [_buttonReset setTitle:NSLocalizedString(@"BUTTON_RESET", nil) forState:UIControlStateNormal];
        [_buttonDelete setTitle:NSLocalizedString(@"BUTTON_DELETE", nil) forState:UIControlStateNormal];
    }


    // ON PAGE FUNCTION

    - (void) generateQuery
    {
        NSString* stringName = [_functionUserInterface generateQueryParameter:_textFieldName.text];
        NSString* stringSocialNumber = [_functionUserInterface generateQueryParameter:_textFieldSocialNumber.text];
        NSString* stringSPAJNumber = [_functionUserInterface generateQueryParameter:_textFieldSPAJNumber.text];
        
        _arrayQuerySubmitted = [_querySPAJHeader selectForSubmittedList:stringName stringSocialNumber:stringSocialNumber stringSPAJNumber:stringSPAJNumber];
        
        [self.tableView reloadData];
    }


    // ACTION

    - (IBAction)actionSearch:(id)sender
    {
        [self generateQuery];
    };

    - (IBAction)actionReset:(id)sender
    {
        [_functionUserInterface resetTextField:_arrayTextField];
        
        [self generateQuery];
    };

    - (IBAction)actionDelete:(id)sender
    {
        NSString *stringTitle = [ NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ALERT_TITLE_TABLEDELETE", nil), TABLE_NAME_SPAJHEADER];
        NSString *stringMessage = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ALERT_MESSAGE_TABLEDELETE", nil), _stringQueryName];
        
        UIAlertController* alertController = [_functionAlert alertTableDelete : stringTitle stringMessage : stringMessage];
        
        [self presentViewController:alertController animated:true completion:nil];
    };


    // TABLE

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return _arrayQuerySubmitted.count;
    }

    - (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
    {
        return 1;
    }

    - (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
    {
        
    }

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        SPAJSubmittedListCell *cellSPAJSubmitted = (SPAJSubmittedListCell *)[tableView dequeueReusableCellWithIdentifier:@"SPAJSubmittedListCell"];
        
        if (cellSPAJSubmitted == nil)
        {
            NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SPAJ Submitted List Cell" owner:self options:nil];
            cellSPAJSubmitted = [arrayNIB objectAtIndex:0];
        }
        else
        {
            
        }
        
        NSManagedObject* querySubmitted = [_arrayQuerySubmitted objectAtIndex:[indexPath row]];
        
        NSString* stringUpdatedOnDate = [_functionUserInterface generateDate:[querySubmitted valueForKey:COLUMN_SPAJHEADER_UPDATEDON]];
        NSString* stringUpdatedOnTime = [_functionUserInterface generateTime:[querySubmitted valueForKey:COLUMN_SPAJHEADER_UPDATEDON] ];
        
        [cellSPAJSubmitted.labelName setText: [querySubmitted valueForKey:COLUMN_SPAJHEADER_NAME]];
        [cellSPAJSubmitted.labelSocialNumber setText: [querySubmitted valueForKey:COLUMN_SPAJHEADER_SOCIALNUMBER]];
        [cellSPAJSubmitted.labelSPAJNumber setText: [querySubmitted valueForKey:COLUMN_SPAJHEADER_SPAJNUMBER]];
        [cellSPAJSubmitted.labelUpdatedOnDate setText: stringUpdatedOnDate];
        [cellSPAJSubmitted.labelUpdatedOnTime setText: stringUpdatedOnTime];
        [cellSPAJSubmitted.labelProduct setText: [querySubmitted valueForKey:COLUMN_SPAJHEADER_PRODUCTID]];
        [cellSPAJSubmitted.labelState setText: [querySubmitted valueForKey:COLUMN_SPAJHEADER_STATE]];
        [cellSPAJSubmitted.buttonView  setTitle:NSLocalizedString(@"BUTTON_VIEW", nil) forState:UIControlStateNormal];
        return cellSPAJSubmitted;
    }

    - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        SPAJSubmittedListCell *cellSPAJSubmitted = [tableView cellForRowAtIndexPath:indexPath];
        
        _intQueryID = [cellSPAJSubmitted intID];
        _stringQueryName = [cellSPAJSubmitted.labelName text];
    }


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end