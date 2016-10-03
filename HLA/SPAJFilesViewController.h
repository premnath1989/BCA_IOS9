//
//  SPAJFilesViewController.h
//  BLESS
//
//  Created by Basvi on 8/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SPAJFilesDelegate
- (void) loadSPAJTransaction;
@end

@interface SPAJFilesViewController : UIViewController
@property (nonatomic,strong) id <SPAJFilesDelegate> delegateSPAJFiles;

@property (strong, nonatomic) NSDictionary* dictTransaction;
@property (nonatomic,assign) BOOL boolHealthQuestionairre;
@property (nonatomic,assign) BOOL boolThirdParty;

@property (nonatomic, strong) IBOutlet UIButton* buttonSubmit;
@end
