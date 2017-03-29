//
//  SPAJFilesViewController.h
//  BLESS
//
//  Created by Basvi on 8/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSZipArchive.h"
#import "SpinnerUtilities.h"

@protocol SPAJFilesDelegate
- (void) loadSPAJTransaction;
@end

@interface SPAJFilesViewController : UIViewController {
    SpinnerUtilities *spinnerLoading;
}
@property (nonatomic,weak) id <SPAJFilesDelegate> delegateSPAJFiles;

@property (weak, nonatomic) NSDictionary* dictTransaction;
@property (nonatomic,assign) BOOL boolHealthQuestionairre;
@property (nonatomic,assign) BOOL boolThirdParty;

@property (nonatomic, weak) IBOutlet UIButton* buttonSubmit;
@end
