//
//  FSVerticalTabBarController.m
//  iOS-Platform
//
//  Created by Błażej Biesiada on 4/6/12.
//  Copyright (c) 2012 Future Simple. All rights reserved.
//

#import "ClientTabBarController.h"
#import "Login.h"

#import "MainScreen.h"
#import "BasicPlanHandler.h"
#import "SIMenuViewController.h"
#import "NewLAViewController.h"
#import "PayorViewController.h"
#import "SecondLAViewController.h"
#import "BasicPlanViewController.h"
#import "RiderViewController.h"
#import "PremiumViewController.h"
#import "SIListing.h"
#import "AppDelegate.h"
#import "ProspectListing.h"
#import "SIListing.h"
#import "EditProspect.h"

#define DEFAULT_TAB_BAR_HEIGHT 60.0

@interface ClientTabBarController ()
- (void)_performInitialization;

@end

int rrr;

@implementation ClientTabBarController


@synthesize delegate = _delegate;
@synthesize tabBar = _tabBar;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize tabBarWidth = _tabBarWidth;
@synthesize EditProspect = _EditProspect;


- (ClientTabBar *)tabBar
{
    if (_tabBar == nil)
    {
        _tabBar = [[ClientTabBar alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _tabBar.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        _tabBar.delegate = self;
    }
    return _tabBar;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = [viewControllers copy];
    
    // create tab bar items
    if (self.tabBar != nil)
    {
        NSMutableArray *tabBarItems = [NSMutableArray arrayWithCapacity:[self.viewControllers count]];
        for (UIViewController *vc in self.viewControllers)
        {
            [tabBarItems addObject:vc.tabBarItem];
        }
        self.tabBar.items = tabBarItems;
    }
    
    // select first VC from the new array
    // sets the value for the first time as -1 for the viewController to load itself properly
    _selectedIndex = -1;
    
    self.selectedIndex = [viewControllers count] > 0 ? 0 : INT_MAX;
}


- (UIViewController *)selectedViewController
{
    if (self.selectedIndex < [self.viewControllers count])
    {
        return [self.viewControllers objectAtIndex:self.selectedIndex];
    }
    return nil;
}


- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    self.selectedIndex = [self.viewControllers indexOfObject:selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{    
    if (selectedIndex != _selectedIndex && selectedIndex < [self.viewControllers count])
    {
        [self.view endEditing:YES];
        [self resignFirstResponder];
        
        Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
        id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
        [activeInstance performSelector:@selector(dismissKeyboard)];
        
        // add new view controller to hierarchy
        UIViewController *selectedViewController = [self.viewControllers objectAtIndex:selectedIndex];
        
        if (selectedIndex == 0 ||selectedIndex == 3) {
            
            [self presentViewController:selectedViewController animated:NO completion:Nil];
            [self updateTabBar];
        }
        else {
            if (selectedIndex == 1||selectedIndex == 2) {
                NSLog(@"selected index %i",selectedIndex);
                [self addChildViewController:selectedViewController];
                selectedViewController.view.frame = CGRectMake(self.tabBarWidth,
                                                                   0,
                                                                   self.view.bounds.size.width-self.tabBarWidth,
                                                                   self.view.bounds.size.height);
                selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                [self.view addSubview:selectedViewController.view];
                [self updateTabBar];
            }
        }
        selectedViewController = Nil;
    }
}

-(void)updateTabBar
{
    UIViewController *selectedViewController = [self.viewControllers objectAtIndex:clickIndex];
    _selectedIndex = clickIndex;
    if ([self.view subviews].count > 1) {
        NSLog(@"selcted index %i",_selectedIndex);
		if (_selectedIndex == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:self];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"returnToListing" object:nil];
		}
    }
    
	if (selectedIndexPath.row ==2 && clickIndex ==1 && _selectedIndex == 1) {
		clickIndex = 2;
	}

    // set new selected index
    //_selectedIndex = clickIndex;
	
    // update tab bar
    if (clickIndex < [self.tabBar.items count])
    {
        self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:clickIndex];
    }
    
    // inform delegate
    if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [self.delegate tabBarController:self didSelectViewController:selectedViewController];
    }
    selectedViewController = Nil;
}

-(void)updateTabBar2
{
    UIViewController *selectedViewController = [self.viewControllers objectAtIndex:clickIndex];
    
    // set new selected index
    _selectedIndex = clickIndex;
    
    // update tab bar
    if (clickIndex < [self.tabBar.items count])
    {
        self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:clickIndex];
    }
    
    // inform delegate
    if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [self.delegate tabBarController:self didSelectViewController:selectedViewController];
    }
    selectedViewController = Nil;
}

- (void)_performInitialization
{
    self.tabBarWidth = DEFAULT_TAB_BAR_HEIGHT;
    self.selectedIndex = INT_MAX;
    _tabBarColor = [UIColor colorWithRed:250.0/255.0 green:175.0/255.0 blue:50.0/255.0 alpha:1.0];
}        

#pragma mark -
#pragma mark UIViewController
- (id)init
{
    if ((self = [super init]))
    {
        [self _performInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self _performInitialization];
    }
    return self;
}


- (void)loadView
{
    UIView *layoutContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    layoutContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    layoutContainerView.autoresizesSubviews = YES;
    
    // create tab bar
    self.tabBar.frame = CGRectMake(0, 20, self.tabBarWidth, layoutContainerView.bounds.size.height);
    [layoutContainerView addSubview:self.tabBar];
    
    //[self.tabBar setBackgroundColor:_tabBarColor];
    [layoutContainerView setBackgroundColor:[UIColor blackColor]];

    
    // return a ready view
    self.view = layoutContainerView;
}	


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    UIViewController *selectedViewController = self.selectedViewController;
    if (selectedViewController != nil)
    {
        return [selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    return YES;
}


#pragma mark -
#pragma mark FSVerticalTabBarController
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    self.viewControllers = viewControllers;
}


#pragma mark -
#pragma mark <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(rrr != 2) {
		clickIndex = indexPath.row;
		
		/*if (indexPath.row == 3) {
        
			UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@" ",nil)
                              message: NSLocalizedString(@"Are you sure you want to log out?",nil)
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                              otherButtonTitles: NSLocalizedString(@"No",nil), nil];
			[alert setTag:1001];
			[alert show];
			alert = Nil;
		}
		else {*/
			[self setSelectedIndex:indexPath.row];
		//}
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
	
    if (alertView.tag == 1001 && buttonIndex == 0)
    {
		[self updateDateLogout];
        
        Login *mainLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        mainLogin.modalPresentationStyle = UIModalPresentationFullScreen;
        mainLogin.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:mainLogin animated:YES completion:nil];

    }    
    else if (alertView.tag == 1001 && buttonIndex == 1) //cancel logout
    {
		
		NSIndexPath *cip = [NSIndexPath indexPathForRow:clickIndex inSection:0] ;
		[ClientTableView selectRowAtIndexPath:cip animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self setSelectedIndex:cip.row];
		
		self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:_selectedIndex];
    }
	else if (alertView.tag == 9001 && buttonIndex == 0) //YES -- ##Add By Emi 01/07/2014, Update Client Profile if Yes
    {
		
		[ClientProfile setObject:@"YES" forKey:@"TabBar"];
		[ClientProfile setObject:@"YES" forKey:@"ReSave"];  //only use for AnnIncome
		
		NSString *exist;
		NSString *confirmCase;
		
		//check for validation
		if ([[ClientProfile objectForKey:@"isEdited"] isEqualToString:@"YES"]) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"EditProfile_validate" object:nil];
			exist = [ClientProfile objectForKey:@"exist"];
			confirmCase = [ClientProfile objectForKey:@"confirmCase"];
		}
		else if ([[ClientProfile objectForKey:@"isNew"] isEqualToString:@"YES"]) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"NewProfileValidate" object:nil];
			bool exist2 = [ClientProfile objectForKey:@"new_exist"];
			if (exist2)
				exist = @"1";
			confirmCase = [ClientProfile objectForKey:@"new_confirmCase"];
		}
	
        NSString *Validation = [ClientProfile objectForKey:@"Validation"];
		[ClientProfile setObject:@"2" forKey:@"TabBar1"]; //ENS: test 1
		
		if ([Validation isEqualToString:@"1"]) {
			if([exist isEqualToString:@"1"])
			{
				if([confirmCase isEqualToString:@"1"])
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Ada tertunda kasus eApp untuk nasabah ini. Haruskah Anda ingin melanjutkan, sistem akan otomatis menghapus semua pending kasus eApp terkait dan Anda diminta untuk menciptakan diperlukan jika Anda ingin mengirimkan kembali kasus ini." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
					[alert setTag:1111];
					[alert show];
				}
				else
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Semua perubahan akan diperbarui untuk berhubungan SI, CFF dan SPAJ. Apakah Anda ingin melanjutkan?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
					[alert setTag:1111];
					[alert show];
				}
				
			}
			else{
				
				UIAlertView *SuccessAlert;
				
				if ([[ClientProfile objectForKey:@"isEdited"] isEqualToString:@"YES"]) {
					[[NSNotificationCenter defaultCenter] postNotificationName:@"EditProfile_Save" object:nil]; //Go to SaveToDb
					SuccessAlert = [[UIAlertView alloc] initWithTitle:@" "
																		   message:@"Perubahan telah diperbarui berhasil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
					SuccessAlert.tag = 1112;
					[SuccessAlert show];
				}
				else if ([[ClientProfile objectForKey:@"isNew"] isEqualToString:@"YES"]) {
					[[NSNotificationCenter defaultCenter] postNotificationName:@"NewProfileSave" object:nil];
					
					if (![[ClientProfile objectForKey:@"Update_record"] isEqualToString:@"YES"]) {
						SuccessAlert = [[UIAlertView alloc] initWithTitle:@" "
																  message:@"Sebuah catatan klien baru berhasil dimasukkan." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    }
					else {
						SuccessAlert = [[UIAlertView alloc] initWithTitle:@" "
																  message:@"Perubahan telah diperbarui berhasil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    }
					
					SuccessAlert.tag = 1112;
					[SuccessAlert show];
					
					[ClientProfile setObject:@"NO" forKey:@"isNew"];
				
				}
			}
		}
		
		[ClientProfile setObject:@"NO" forKey:@"isEdited"]; //edit profile
		[ClientProfile setObject:@"NO" forKey:@"isNew"];	//add new profile
		
    }
    else if (alertView.tag == 9001 && buttonIndex == 1) //NO
    {
		NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
		[ClientProfile setObject:@"NO" forKey:@"isEdited"];
		[ClientProfile setObject:@"NO" forKey:@"isNew"];
		[ClientProfile setObject:@"NO" forKey:@"ReSave"];
		
		if (selectedIndexPath.row == 3) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@" ",nil)
                                  message: NSLocalizedString(@"akah Anda yakin Anda ingin log out?",nil)
                                  delegate: self
                                  cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                                  otherButtonTitles: NSLocalizedString(@"No",nil), nil];
            [alert setTag:1001];
            
            [alert show];
            alert = Nil;
		}
		else if (selectedIndexPath.row == 0) {
			[self handleTableViewSelection:YES];
		}
		else if (selectedIndexPath.row == 2) {
			[self handleTableViewSelection:YES];
		}
    }
	else if (alertView.tag == 1111 && buttonIndex == 0) //YES
    {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"EditProfile_Save" object:nil]; //Go to SaveToDb
		UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@" "
															   message:@"Perubahan telah diperbarui berhasil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		
		
		SuccessAlert.tag = 1112;
		[SuccessAlert show];
		
    }
	else if (alertView.tag == 1111 && buttonIndex == 1) //YES
    {
		[self handleTableViewSelection:YES];
    }
	else if (alertView.tag == 1112) //Success Save
    {
		NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
		if (selectedIndexPath.row == 3) {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: NSLocalizedString(@" ",nil)
								  message: NSLocalizedString(@"akah Anda yakin Anda ingin log out?",nil)
								  delegate: self
								  cancelButtonTitle: NSLocalizedString(@"Yes",nil)
								  otherButtonTitles: NSLocalizedString(@"No",nil), nil];
			[alert setTag:1001];
			[alert show];
			alert = Nil;
		}
		else if (selectedIndexPath.row == 1) {
			//return to same page, but clear all value to avoid saving same record
			if ([[ClientProfile objectForKey:@"ChangedOn"] isEqualToString:@"NEW"]) {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAfterSave" object:nil];
			}
		}
		else if (selectedIndexPath.row == 0) {
			[self handleTableViewSelection:YES];
		}
		else if (selectedIndexPath.row == 2) {
			[self handleTableViewSelection:YES];
		}
    }
}

-(void)handleTableViewSelection:(BOOL)result
{
    if (result && rrr != 2) {
        [ClientTableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self setSelectedIndex:selectedIndexPath.row];
    }
    else {		
        [ClientTableView selectRowAtIndexPath:currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self setSelectedIndex:currentIndexPath.row];
    }
}

-(void)updateDateLogout
{
    NSString *databasePath;
    sqlite3 *contactDB;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    Login *mainLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    mainLogin.modalPresentationStyle = UIModalPresentationFullScreen;
    mainLogin.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mainLogin animated:YES completion:nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET LastLogoutDate= \"%@\" WHERE IndexNo=\"%d\"",dateString, 1];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    databasePath = Nil;
    contactDB = Nil, dirPaths = Nil, docsDir = Nil, databasePath= Nil, mainLogin = Nil, dateFormatter = Nil, dateString = Nil;
    dbpath = Nil, statement = Nil, contactDB = Nil;
    
    exit(0);
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL result = false;
	ClientTableView = tableView;

	// to prevent user from switching to other tab on main side bar when report is still generating
    if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        UIViewController *newController = [self.viewControllers objectAtIndex:indexPath.row];
        result = [self.delegate tabBarController:self shouldSelectViewController:newController];
    }
    
    if (result) {
		if (rrr == 2) {
			return tableView.indexPathForSelectedRow;
		}
    }
    else {
        return tableView.indexPathForSelectedRow;
    }
    
	//Add by Emi, prompt message if there change in client profile
	
	NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
	NSString *isEdited = [ClientProfile stringForKey:@"isEdited"];
	NSString *isNew = [ClientProfile stringForKey:@"isNew"];
	NSString *prospectID = [ClientProfile stringForKey:@"ProspectId"];
	
	[ClientProfile setObject:@"1" forKey:@"TabBar1"]; //ENS: test 1
	
	if ([isNew isEqualToString:@"NO"]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"CheckIfEmpty" object:nil];
	}
	if ([isEdited isEqualToString:@"NO"]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"CheckEdited" object:nil];
	} 
	
	isEdited = [ClientProfile stringForKey:@"isEdited"];
	isNew = [ClientProfile stringForKey:@"isNew"];
	
	if([isEdited isEqualToString:@"YES"] || [isNew isEqualToString:@"YES"])
    {  
        NSString *confirm_case;
        NSString *eProposalNo;
        NSString *IDTypeNo;
        NSString *OtherIDType;
        NSString *OtherIDTypeNo;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:@"hladb.sqlite"];
        
        FMDatabase *database = [FMDatabase databaseWithPath:path];
        [database open];
        
        // Check Policy Owner, LA1, LA2
        FMResultSet *result_checkLA = [database executeQuery:@"SELECT * from eProposal_LA_Details WHERE ProspectProfileID = ?", prospectID];
        FMResultSet *result_check_proposal;
        while ([result_checkLA next]) {
            eProposalNo =  [result_checkLA objectForColumnName:@"eProposalNo"];
            result_check_proposal = [database executeQuery:@"SELECT * from eApp_Listing WHERE ProposalNo = ? AND Status = ?", eProposalNo,@"3"];
            
            while ([result_check_proposal next]) {
                confirm_case =  [result_checkLA objectForColumnName:@"Name"];
            }
        }
        
        // to get IC, OtherID and OtherIDNo
        FMResultSet *get_IC = [database executeQuery:@"SELECT * from prospect_profile WHERE IndexNo = ?", prospectID];
        while ([get_IC next]) {
            IDTypeNo =  [get_IC objectForColumnName:@"IDTypeNo"];
            OtherIDType =  [get_IC objectForColumnName:@"OtherType"];
            OtherIDTypeNo =  [get_IC objectForColumnName:@"OtherTypeNo"];
        }
        
        // check PO Family
        FMResultSet *result_checkFamily = [database executeQuery:@"SELECT * from eProposal_CFF_Family_Details WHERE ClientProfileID = ?", prospectID];
        while ([result_checkFamily next]) {
            eProposalNo =  [result_checkFamily objectForColumnName:@"eProposalNo"];
            result_check_proposal = [database executeQuery:@"SELECT * from eApp_Listing WHERE ProposalNo = ? AND Status = ?", eProposalNo,@"3"];
            while ([result_check_proposal next]) {
                confirm_case =  [result_checkFamily objectForColumnName:@"Name"];
            }
        }
        
        // check PO Spouse
        FMResultSet *result_checkSpouse = [database executeQuery:@"SELECT * from eProposal_CFF_Personal_Details WHERE NewICNo = ? AND (OtherIDType = ? AND OtherID = ?)", IDTypeNo,OtherIDType,OtherIDTypeNo];
        while ([result_checkSpouse next]) {
            eProposalNo =  [result_checkSpouse objectForColumnName:@"eProposalNo"];
            result_check_proposal = [database executeQuery:@"SELECT * from eApp_Listing WHERE ProposalNo = ? AND Status = ?", eProposalNo,@"3"];
            while ([result_check_proposal next]) {
                confirm_case =  [result_checkSpouse objectForColumnName:@"Name"];
            }
        }
        
        [result_checkLA close];
        [result_checkFamily close];
        [result_checkSpouse close];        
        [database close];

        if(confirm_case!=nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Ada tertunda kasus eApp untuk klien ini. Haruskah Anda ingin melanjutkan, sistem akan otomatis menghapus semua pending kasus eApp terkait dan Anda diminta untuk menciptakan diperlukan jika Anda ingin mengirimkan kembali kasus ini." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            [alert setTag:9001];
            [alert show];
        }
        else
        {
            [self hideKeyboard];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Anda ingin menyimpan perubahan?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
            [alert setTag:9001];
            [alert show];
            
        }
        
        currentIndexPath = [tableView indexPathForSelectedRow];
        selectedIndexPath = indexPath;
    
        return currentIndexPath;
    }
	else{
		return indexPath;
	}

}


- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

-(void)Test{
	rrr = 2;
}

-(void)FinishEdit {
    
}

-(void)Reset{
	rrr = 0;
}

-(void)hideKeyboard{
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
    
}

@end
