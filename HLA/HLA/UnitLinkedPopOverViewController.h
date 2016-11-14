//
//  UnitLinkedPopOverViewController.h
//  BLESS
//
//  Created by Basvi on 11/11/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UnitLinkedPopOverDelegate
    -(void)TableData:(NSString *)stringDesc TableCode:(NSString *)stringCode;
@end

@interface UnitLinkedPopOverViewController : UIViewController{
    IBOutlet UITableView* tablePopOver;
    IBOutlet UINavigationBar* navigationPopOver;
    IBOutlet UINavigationItem* navigationItemPopOver;
}
@property (nonatomic,weak) id <UnitLinkedPopOverDelegate> UnitLinkedPopOverDelegate;
-(void)setTablData:(NSDictionary *)dictTableData Title:(NSString *)stringTitle;
@end
