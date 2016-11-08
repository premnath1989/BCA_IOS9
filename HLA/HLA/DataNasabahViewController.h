//
//  DataNasabahViewController.h
//  BLESS
//
//  Created by Basvi on 6/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSpouseViewController.h"
#import "AddChildViewController.h"
#import "ProspectProfile.h"
#import "ModelProspectProfile.h"
#import "ModelProspectSpouse.h"
#import "ModelProspectChild.h"

@interface DataNasabahViewController : UIViewController<AddSpouseViewControllerDelegate,AddChildViewControllerDelegate>{
    AddSpouseViewController* addSpouseVC;
    AddChildViewController* addChildVC;
    ModelProspectProfile* modelProspectProfile;
    ModelProspectSpouse* modelProspectSpouse;
    ModelProspectChild* modelProspectChild;
}

@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;
@property (strong, nonatomic) NSDictionary* cffHeaderSelectedDictionary;

@end
