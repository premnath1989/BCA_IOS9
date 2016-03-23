//
//  KeluargakuTableViewCell.h
//  BLESS
//
//  Created by Basvi on 3/22/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeluargakuTableViewCell : UITableViewCell{
}
@property (nonatomic, weak)IBOutlet UILabel* labelManfaat;
@property (nonatomic, weak)IBOutlet UILabel* labelUangPertanggungan;
@property (nonatomic, weak)IBOutlet UILabel* labelMasaAsuransi;
@property (nonatomic, weak)IBOutlet UILabel* labelUnit;
@property (nonatomic, weak)IBOutlet UILabel* labelExtraPremiPercent;
@property (nonatomic, weak)IBOutlet UILabel* labelExtraPremiPerMil;
@property (nonatomic, weak)IBOutlet UILabel* labelMasaExtraPremi;
@property (nonatomic, weak)IBOutlet UILabel* labelExraPremiRp;
@property (nonatomic, weak)IBOutlet UILabel* labelPremiRp;

@end
