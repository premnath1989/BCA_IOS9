//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Existing List.h"
#import "Query SPAJ Header.h"
#import "SPAJ Existing List Cell.h"
#import "String.h"
#import "Alert.h"


// DECLARATION

@interface SPAJExistingList ()



@end


// IMPLEMENTATION


@implementation SPAJExistingList

    // SYNTHESIZE

    @synthesize querySPAJHeader = _querySPAJHeader;
    @synthesize functionUserInterface = _functionUserInterface;
    @synthesize arrayQueryExisting = _arrayQueryExisting;
    @synthesize arrayTextField = _arrayTextField;
    @synthesize functionAlert = _functionAlert;
    @synthesize intQueryID = _intQueryID;
    @synthesize stringQueryName = _stringQueryName;


    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // INITIALIZATION
        
        _querySPAJHeader = [[QuerySPAJHeader alloc]init];
        _functionUserInterface = [[UserInterface alloc] init];
        _functionAlert = [[Alert alloc]init];
        
        
        // LAYOUT SETTING
        
        _stackViewNote.alignment = UIStackViewAlignmentTop;
        
        _arrayTextField = [[NSMutableArray alloc] init];
        [_arrayTextField addObject:_textFieldName];
        [_arrayTextField addObject:_textFieldSPAJNumber];
        [_arrayTextField addObject:_textFieldSocialNumber];
        
        [_tableView.delegate self];
        [_tableView.dataSource self];
        
        
        // DEFAULT QUERY
        
        [self generateQuery];
        
        
        // LOCALIZATION
        
        _labelPageTitle.text = NSLocalizedString(@"TITLE_SPAJEXISTINGLIST", nil);
        
        _labelNoteHeader.text = NSLocalizedString(@"NOTE_SPAJHEADER", nil);
        _labelNoteDetail.text = NSLocalizedString(@"NOTE_SPAJDETAIL", nil);
        _labelFieldName.text = NSLocalizedString(@"FIELD_NAME", nil);
        _labelFieldSPAJNumber.text = NSLocalizedString(@"FIELD_SPAJNUMBER", nil);
        _labelFieldSocialNumber.text = NSLocalizedString(@"FIELD_SOCIALNUMBER", nil);
        
        _labelTablePolicyHolder.text = NSLocalizedString(@"TABLE_HEADER_POLICYHOLDER", nil);
        _labelTableSPAJNumber.text = NSLocalizedString(@"TABLE_HEADER_SPAJNUMBER", nil);
        _labelTableLastUpdateOn.text = NSLocalizedString(@"TABLE_HEADER_LASTUPDATEDON", nil);
        _labelTableSIVersion.text = NSLocalizedString(@"TABLE_HEADER_ILLUSTRATIONVERSION", nil);
        _labelTableTimeRemaining.text = NSLocalizedString(@"TABLE_HEADER_TIMEREMAINING", nil);
        _labelTableView.text = NSLocalizedString(@"TABLE_HEADER_VIEW", nil);
        
        [_buttonSearch setTitle:NSLocalizedString(@"BUTTON_SEARCH", nil) forState:UIControlStateNormal];
        [_buttonReset setTitle:NSLocalizedString(@"BUTTON_RESET", nil) forState:UIControlStateNormal];
        [_buttonDelete setTitle:NSLocalizedString(@"BUTTON_DELETE", nil) forState:UIControlStateNormal];
    }


    // ON PAGE FUNCTION

    - (void)generateQuery
    {
        NSString* stringName = [_functionUserInterface generateQueryParameter:_textFieldName.text];
        NSString* stringSocialNumber = [_functionUserInterface generateQueryParameter:_textFieldSocialNumber.text];
        NSString* stringSPAJNumber = [_functionUserInterface generateQueryParameter:_textFieldSPAJNumber.text];
        
        _arrayQueryExisting = [_querySPAJHeader selectForExistingList:stringName stringSocialNumber:stringSocialNumber stringSPAJNumber:stringSPAJNumber];
        
        [self.tableView reloadData];
    }


    // ACTION

    - (IBAction)actionSearch:(id)sender
    {
        [self generateQuery];
    };

    - (IBAction)actionDelete:(id)sender
    {
        NSString *stringTitle = [ NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ALERT_TITLE_TABLEDELETE", nil), TABLE_NAME_SPAJHEADER];
        NSString *stringMessage = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ALERT_MESSAGE_TABLEDELETE", nil), _stringQueryName];
        
        UIAlertController* alertController = [_functionAlert alertTableDelete : stringTitle stringMessage : stringMessage];
        
        [self presentViewController:alertController animated:true completion:nil];
    };

    - (IBAction)actionReset:(id)sender
    {
        [_functionUserInterface resetTextField:_arrayTextField];
        
        [self generateQuery];
    };


    // TABLE

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return _arrayQueryExisting.count;
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
        SPAJExistingListCell *cellSPAJExisting = (SPAJExistingListCell *)[tableView dequeueReusableCellWithIdentifier:@"SPAJExistingListCell"];
        
        if (cellSPAJExisting == nil)
        {
            NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SPAJ Existing List Cell" owner:self options:nil];
            cellSPAJExisting = [arrayNIB objectAtIndex:0];
        }
        else
        {
            
        }
        
        NSManagedObject* queryExisting = [_arrayQueryExisting objectAtIndex:[indexPath row]];
        
        NSString* stringUpdatedOnDate = [_functionUserInterface generateDate:[queryExisting valueForKey:COLUMN_SPAJHEADER_UPDATEDON]];
        NSString* stringUpdatedOnTime = [_functionUserInterface generateTime:[queryExisting valueForKey:COLUMN_SPAJHEADER_UPDATEDON] ];
        NSString* stringTimeRemaining = [_functionUserInterface generateTimeRemaining:[queryExisting valueForKey:COLUMN_SPAJHEADER_CREATEDON]];
        
        [cellSPAJExisting.labelName setText: [queryExisting valueForKey:COLUMN_SPAJHEADER_NAME]];
        [cellSPAJExisting.labelSocialNumber setText: [queryExisting valueForKey:COLUMN_SPAJHEADER_SOCIALNUMBER]];
        [cellSPAJExisting.labelSPAJNumber setText: [queryExisting valueForKey:COLUMN_SPAJHEADER_SPAJNUMBER]];
        [cellSPAJExisting.labelUpdatedOnDate setText: stringUpdatedOnDate];
        [cellSPAJExisting.labelUpdatedOnTime setText: stringUpdatedOnTime];
        [cellSPAJExisting.labelSalesIllustration setText: [queryExisting valueForKey:COLUMN_SPAJHEADER_ILLUSTRATIONID]];
        [cellSPAJExisting.labelTimeRemaining setText: stringTimeRemaining];
        [cellSPAJExisting.buttonView  setTitle:NSLocalizedString(@"BUTTON_VIEW", nil) forState:UIControlStateNormal];
        
        return cellSPAJExisting;
    }

    - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        SPAJExistingListCell *cellSPAJExisting = [tableView cellForRowAtIndexPath:indexPath];
        
        _intQueryID = [cellSPAJExisting intID];
        _stringQueryName = [cellSPAJExisting.labelName text];
    }


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end