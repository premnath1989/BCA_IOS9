//
//  SAMActivityDetailViewController.h
//  BLESS
//
//  Created by Basvi on 12/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMDBHelper.h"
#import "SAMModel.h"
#import "SAMMeetingNoteModel.h"

@interface SAMActivityDetailViewController : UIViewController {
    SAMDBHelper *dbHelper;
    SAMMeetingNoteModel *note;
}

@property (weak, nonatomic) SAMModel *SAMdata;

@end
