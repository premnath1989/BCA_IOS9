//
//  ProductInformation.h
//  BLESS
//
//  Created by Erwin on 01/03/2016.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "TableManagement.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ProductInformation : UIViewController<ReaderViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSArray *columnHeadersContent;
    TableManagement *tableManagement;
    UIView *TableHeader;
    UIColor *themeColour;
    UIFont *fontType;
}

@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnPDF;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer; 

- (IBAction)goHome:(id)sender;
- (IBAction)seePDF:(id)sender;

@end
