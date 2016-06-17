//
//  AddSpouseViewController.h
//  BLESS
//
//  Created by Basvi on 6/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddSpouseViewControllerDelegate
-(void)reloadProspectData;
@end

@interface AddSpouseViewController : UIViewController
@property (nonatomic,strong) id <AddSpouseViewControllerDelegate> delegate;
@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;
@property (strong, nonatomic) NSDictionary* DictSpouseData;
-(void)loadSpouseData:(NSDictionary *)dictSpouseData;

@end
