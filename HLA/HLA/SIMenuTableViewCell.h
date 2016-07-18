//
//  SIMenuTableViewCell.h
//  BLESS
//
//  Created by Basvi on 2/19/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMenuTableViewCell : UITableViewCell {
}

@property (nonatomic, weak) IBOutlet UILabel* labelNumber;
@property (nonatomic, weak) IBOutlet UILabel* labelDesc;
@property (nonatomic, weak) IBOutlet UILabel* labelWide;
@property (nonatomic, weak) IBOutlet UILabel* labelSubtitle;
@property (nonatomic, weak) IBOutlet UIButton* button1;
@property (nonatomic, weak) IBOutlet UIButton* button2;
@property (nonatomic, weak) IBOutlet UIButton* button3;

@end
