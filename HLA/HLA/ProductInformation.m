//
//  ProductInformation.m
//  BLESS
//
//  Created by Erwin on 01/03/2016.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInformation.h"
#import "CarouselViewController.h"
#import "ReaderViewController.h"
#import "ColumnHeaderStyle.h"
#import "ProductInfoItems.h"

@implementation ProductInformation

@synthesize btnHome;
@synthesize btnPDF;
@synthesize myTableView;
@synthesize navigationBar;
@synthesize moviePlayer;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self createDirectory];
    
    //we test our ftp
    ProductInfoItems *FTPitems = [[ProductInfoItems alloc]init];
    [FTPitems listDirectory];
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] init];
    [newAttributes setObject:[UIFont systemFontOfSize:18] forKey:UITextAttributeFont];
    [self.navigationBar setTitleTextAttributes:newAttributes];
    
    themeColour = [UIColor colorWithRed:0.0f/255.0f green:160.0f/255.0f blue:180.0f/255.0f alpha:1];
    fontType = [UIFont fontWithName:@"BPreplay" size:16.0f];
    
    [self setupTableColumn];
    
    [btnHome addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)createDirectory{
    //create Directory
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Brochures"];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
}

- (void)setupTableColumn{
    //we call the table management to design the table
    ColumnHeaderStyle *ilustrasi = [[ColumnHeaderStyle alloc]init:@" No. " alignment:NSTextAlignmentLeft button:FALSE width:0.05];
    ColumnHeaderStyle *nama = [[ColumnHeaderStyle alloc]init:@"Nama" alignment:NSTextAlignmentCenter button:TRUE width:0.80];
    ColumnHeaderStyle *type = [[ColumnHeaderStyle alloc]init:@"Kategori" alignment:NSTextAlignmentCenter button:TRUE width:0.15];
    
    //add it to array
    columnHeadersContent = [NSArray arrayWithObjects:ilustrasi, nama, type, nil];
    tableManagement = [[TableManagement alloc]init:self.view themeColour:themeColour themeFont:fontType];
    TableHeader =[tableManagement TableHeaderSetupXY:columnHeadersContent
                                         positionY:80.0f positionX:80.0f];
    
    [self.view addSubview:TableHeader];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSInteger row = indexPath.row;
    NSArray *arrayOfData;
    NSLog(@"insert : %d",indexPath.row);
    if(row == 0){
        arrayOfData = [NSArray arrayWithObjects:@"1",@"Brochure_ProdukBCALIfeKeluargaku_21012016", @"brosur",nil];
        [tableManagement TableRowInsert:arrayOfData index:indexPath.row table:cell color:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
    }
    if(row == 1){
        arrayOfData = [NSArray arrayWithObjects:@"2",@"BCA_life_Keluargaku_Video_Testimonial_Part_I_final", @"video", nil];
        [tableManagement TableRowInsert:arrayOfData index:indexPath.row table:cell color:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
    }
    
    return cell;
}

- (IBAction)goHome:(id)sender{
    UIStoryboard *carouselStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
    CarouselViewController* carouselPage = [carouselStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
    [self presentViewController:carouselPage animated:YES completion:Nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"click : %d",indexPath.row);
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:(indexPath.row*1000)+1];
    UILabel *fileType = (UILabel *)[cell viewWithTag:(indexPath.row*1000)+2];
    NSLog(@"file : %@.%@", label.text,fileType.text);
    if([fileType.text caseInsensitiveCompare:@"brosur"] == NSOrderedSame){
        [self seePDF:label.text];
    }else if([fileType.text caseInsensitiveCompare:@"video"] == NSOrderedSame){
        [self seeVideo:label.text];
    }
}

- (IBAction)seePDF:(NSString *)fileName{
    NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf"];
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:file password:nil];
    
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:Nil];
    }
}

- (IBAction)seeVideo:(NSString *)fileName{
    NSString*thePath=[[NSBundle mainBundle] pathForResource:fileName ofType:@"mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    
    moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
    [moviePlayer.view setFrame:self.view.bounds];
    [moviePlayer prepareToPlay];
    [moviePlayer setShouldAutoplay:NO]; // And other options you can look through the documentation.
    moviePlayer.view.tag = MOVIEPLAYER_TAG;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
    [moviePlayer play];
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:moviePlayer];

}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonUserExited)
    {
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        [moviePlayer stop];
        // Dismiss the view controller
        for (UIView *subview in [self.view subviews]) {
            if (subview.tag == MOVIEPLAYER_TAG) {
                [subview removeFromSuperview];
            }
        }
    }
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

@end
