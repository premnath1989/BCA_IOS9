//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ E Application List.h"
#import "Query SPAJ Header.h"
#import "SPAJ E Application List Cell.h"
#import "String.h"



// DECLARATION

@interface SPAJEApplicationList ()



@end


// IMPLEMENTATION

@implementation SPAJEApplicationList

    // SYNTHESIZE

    @synthesize querySPAJHeader = _querySPAJHeader;
    @synthesize functionUserInterface = _functionUserInterface;
    @synthesize arrayQueryEApplication = _arrayQueryEApplication;
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
        _functionAlert = [[Alert alloc] init];
        
        
        // LAYOUT SETTING
        
        _arrayTextField = [[NSMutableArray alloc] init];
        [_arrayTextField addObject:_textFieldName];
        [_arrayTextField addObject:_textFieldEApplicationNumber];
        
        [_tableView.delegate self];
        [_tableView.dataSource self];
        
        
        // DEFAULT QUERY
        
        [self generateQuery];
        
        
        // LOCALIZATION
          
        _labelPageTitle.text = NSLocalizedString(@"TITLE_EAPPLICATIONLIST", nil);
        
        _labelFieldName.text = NSLocalizedString(@"FIELD_NAME", nil);
        _labelFieldEApplicationNumber.text = NSLocalizedString(@"FIELD_EAPPLICATIONNUMBER", nil);
        _labelTablePolicyHolder.text = NSLocalizedString(@"TABLE_HEADER_POLICYHOLDER", nil);
        _labelTableSPAJNumber.text = NSLocalizedString(@"TABLE_HEADER_SPAJNUMBER", nil);
        _labelTableLastUpdateOn.text = NSLocalizedString(@"TABLE_HEADER_LASTUPDATEDON", nil);
        _labelTableEApp.text = NSLocalizedString(@"TABLE_HEADER_EAPPLICATIONNUMBER", nil);
        _labelTableState.text = NSLocalizedString(@"TABLE_HEADER_STATUS", nil);
        
        [_buttonSearch setTitle:NSLocalizedString(@"BUTTON_SEARCH", nil) forState:UIControlStateNormal];
        [_buttonReset setTitle:NSLocalizedString(@"BUTTON_RESET", nil) forState:UIControlStateNormal];
        [_buttonDelete setTitle:NSLocalizedString(@"BUTTON_DELETE", nil) forState:UIControlStateNormal];
    }


    // FUNCTION ON PAGE

    - (void) generateQuery
    {
        NSString* stringName = [_functionUserInterface generateQueryParameter:_textFieldName.text];
        NSString* stringEApplicationNumber = [_functionUserInterface generateQueryParameter:_textFieldEApplicationNumber.text];
        
        _arrayQueryEApplication = [_querySPAJHeader selectForEApplicationList:stringName stringEApplicationNumber:stringEApplicationNumber];
        
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
        return _arrayQueryEApplication.count;
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
        SPAJEApplicationListCell *cellSPAJEApplication = (SPAJEApplicationListCell *)[tableView dequeueReusableCellWithIdentifier:@"SPAJEApplicationListCell"];
        
        if (cellSPAJEApplication == nil)
        {
            NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SPAJ E Application List Cell" owner:self options:nil];
            cellSPAJEApplication = [arrayNIB objectAtIndex:0];
        }
        else
        {
            
        }
        
        NSManagedObject* queryEApplication = [_arrayQueryEApplication objectAtIndex:[indexPath row]];
        
        NSString* stringUpdatedOnDate = [_functionUserInterface generateDate:[queryEApplication valueForKey:COLUMN_SPAJHEADER_UPDATEDON]];
        NSString* stringUpdatedOnTime = [_functionUserInterface generateTime:[queryEApplication valueForKey:COLUMN_SPAJHEADER_UPDATEDON] ];
        
        [cellSPAJEApplication.labelName setText: [queryEApplication valueForKey:COLUMN_SPAJHEADER_NAME]];
        [cellSPAJEApplication.labelSocialNumber setText: [queryEApplication valueForKey:COLUMN_SPAJHEADER_SOCIALNUMBER]];
        [cellSPAJEApplication.labelEApplicationNumber setText: [queryEApplication valueForKey:COLUMN_SPAJHEADER_EAPPLICATIONNUMBER]];
        [cellSPAJEApplication.labelSPAJNumber setText: [queryEApplication valueForKey:COLUMN_SPAJHEADER_SPAJNUMBER]];
        [cellSPAJEApplication.labelUpdatedOnDate setText: stringUpdatedOnDate];
        [cellSPAJEApplication.labelUpdatedOnTime setText: stringUpdatedOnTime];
        [cellSPAJEApplication.labelState setText: [queryEApplication valueForKey:COLUMN_SPAJHEADER_STATE]];
        return cellSPAJEApplication;
    }

    - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        SPAJEApplicationListCell *cellSPAJEApplication = [tableView cellForRowAtIndexPath:indexPath];
        
        _intQueryID = [cellSPAJEApplication intID];
        _stringQueryName = [cellSPAJEApplication.labelName text];
    }


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end