//
//  SIListingTableViewCell.h
//  BLESS
//
//  Created by Basvi on 2/26/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIListingTableViewCell : UITableViewCell{

}
@property (nonatomic, weak) IBOutlet UIButton* buttonShowIlustrasi;
@property (nonatomic, weak) IBOutlet UIImageView* imageShowIlustrasi;
@property (nonatomic, weak) IBOutlet UILabel* labelIlusrationNo;
@property (nonatomic, weak) IBOutlet UILabel* labelIlustrationDate;
@property (nonatomic, weak) IBOutlet UILabel* labelPOName;
@property (nonatomic, weak) IBOutlet UILabel* labelProduct;
@property (nonatomic, weak) IBOutlet UILabel* labelSumAssured;
@property (nonatomic, weak) IBOutlet UILabel* labelStatus;
@end
