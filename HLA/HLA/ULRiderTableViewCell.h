//
//  ULRiderTableViewCell.h
//  BLESS
//
//  Created by Basvi on 12/5/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ULRiderTableViewCell : UITableViewCell{
    }
@property (nonatomic, weak)IBOutlet UILabel* labelManfaat;
@property (nonatomic, weak)IBOutlet UILabel* labelSumAssured;
@property (nonatomic, weak)IBOutlet UILabel* labelMasaAsuransi;
@property (nonatomic, weak)IBOutlet UILabel* labelUnit;
@property (nonatomic, weak)IBOutlet UILabel* labelExtraPremiPercent;
@property (nonatomic, weak)IBOutlet UILabel* labelExtraPremiPerMil;
@property (nonatomic, weak)IBOutlet UILabel* labelMasaExtraPremi;
@property (nonatomic, weak)IBOutlet UILabel* labelExtraPremiRp;
@property (nonatomic, weak)IBOutlet UILabel* labelPremiRp;

@end
