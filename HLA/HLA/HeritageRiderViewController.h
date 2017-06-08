//
//  HeritageRiderViewController.h
//  BLESS
//
//  Created by Basvi on 6/2/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeritageRiderViewController;
@protocol HeritageRiderViewControllerDelegate
-(NSMutableDictionary *)getPOLAData;
-(NSMutableArray *)getHeritageRiderData:(NSString *)stringSINO;
-(NSMutableDictionary *)getBasicPlanData;
-(void)setHeritageRiderData:(NSString *)stringSINO ArrayRiderHeritage:(NSMutableArray *)arrayRider;
-(void)saveRiderData:(NSDictionary *)dictRiderData;
-(void)showPremiumPage;
@end
@interface HeritageRiderViewController : UIViewController{
    IBOutlet UISegmentedControl *segmentPersonType;
    IBOutlet UIButton *btnAddRider;
    IBOutlet UIButton *btnRiderName;
    IBOutlet UITextField *occpField;
    IBOutlet UITextField *sumAssuredField;
    IBOutlet UITextField *basicPremiField;
    IBOutlet UITextField *extraPremiPercentField;
    IBOutlet UITextField *extraPremiNumberField;
    IBOutlet UITextField *masaExtraPremiField;
    IBOutlet UITextField *masaRiderAsuransiField;
    
    IBOutlet UITableView* tableRider;
}
@property (nonatomic,strong) id <HeritageRiderViewControllerDelegate> delegate;
@end
