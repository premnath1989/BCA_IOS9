//
//  SIMenuUnitLinkedViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMenuTableViewCell.h"
@protocol ULMenuViewControllerDelegate
-(void)showQuotation:(UIViewController *)viewControllerQuotation SINumber:(NSString *)stringSINumber;
- (IBAction)brochureTapped:(UIButton *)sender;
- (IBAction)SaveTapped:(UIButton *)sender;
-(void)SetUnitLinkedSINumber:(NSString *)stringSINumber;

-(void)dismissUnitLinkedView:(NSMutableDictionary *)dictionaryPOLA;
@end

@interface SIMenuUnitLinkedViewController : UIViewController{
    IBOutlet UITableView *myTableView;
    IBOutlet UIView* viewRightView;
    
    IBOutlet UIButton *outletSaveAs;
    
    NSString* stringSINumber;
    NSString* stringProductName;
    NSString* stringProductCode;
    NSMutableDictionary* dictParentPOLAData;
    NSMutableDictionary* dictParentULBasicPlanData;
    NSMutableDictionary* dictParentULFundAllocationData;
    NSMutableArray* arraySpecialOptionData;
    NSMutableArray* arrayRiderData;
}
@property (nonatomic,strong) id <ULMenuViewControllerDelegate> delegate;
@property (nonatomic,weak)NSString* stringSIDate;
-(void)setBOOLSectionFilled;
-(void)setIllustrationNumber:(NSString *)stringIllustrationNumber;
-(void)setInitialPOLADictionary;
-(void)setExchangePOLADictionary:(NSMutableDictionary *)dictPOLAdata;
-(void)setInitialULBasicPlanDictionary;
-(void)setInitialULFundAllocationDictionary;
-(void)setInitialULSpecialOptionDictionary;
-(void)setInitialULRiderArray;
-(void)showUnitLinkModuleAtIndex:(NSIndexPath *)indexPath;
- (void) checkEditingMode;
@end
