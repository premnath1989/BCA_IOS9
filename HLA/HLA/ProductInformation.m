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

@implementation ProductInformation

@synthesize btnHome;
@synthesize btnPDF;
@synthesize myTableView;
@synthesize navigationBar;
@synthesize moviePlayer;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self createDirectory];
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] init];
    [newAttributes setObject:[UIFont systemFontOfSize:18] forKey:UITextAttributeFont];
    [self.navigationBar setTitleTextAttributes:newAttributes];
    
    themeColour = [UIColor colorWithRed:0.0f/255.0f green:160.0f/255.0f blue:180.0f/255.0f alpha:1];
    fontType = [UIFont fontWithName:@"BPreplay" size:16.0f];
    
    [self setupTableColumn];
    
    [btnHome addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    [btnPDF addTarget:self action:@selector(seePDF:) forControlEvents:UIControlEventTouchUpInside];
    
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
    ColumnHeaderStyle *ilustrasi = [[ColumnHeaderStyle alloc]init:@" No. Brosur" alignment:NSTextAlignmentLeft button:FALSE width:0.15];
    ColumnHeaderStyle *nama = [[ColumnHeaderStyle alloc]init:@"Nama Brosur" alignment:NSTextAlignmentCenter button:TRUE width:0.70];
    ColumnHeaderStyle *type = [[ColumnHeaderStyle alloc]init:@"Tipe" alignment:NSTextAlignmentCenter button:TRUE width:0.15];
    
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
    if(row == 0)
        arrayOfData = [NSArray arrayWithObjects:@"1",@"Brochure_ProdukBCALIfeKeluargaku", @"pdf",nil];
    [tableManagement TableRowInsert:arrayOfData index:indexPath.row table:cell color:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
    if(row == 1)
        arrayOfData = [NSArray arrayWithObjects:@"2",@"BCA_life_Keluargaku_Video_Testimonial_Part_I_final", @"video", nil];
    [tableManagement TableRowInsert:arrayOfData index:indexPath.row table:cell color:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
    
    return cell;
}

- (IBAction)goHome:(id)sender{
    UIStoryboard *carouselStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
    CarouselViewController* carouselPage = [carouselStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
    [self presentViewController:carouselPage animated:YES completion:Nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:pathToLastRow];
    NSLog(@"click : %d",pathToLastRow.row);
    UILabel *label = (UILabel *)[cell viewWithTag:1002];
    UILabel *fileType = (UILabel *)[cell viewWithTag:1003];
    if([fileType.text caseInsensitiveCompare:@"pdf"]){
        [self seePDF:label.text];
    }else if([fileType.text caseInsensitiveCompare:@"video"]){
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
    [moviePlayer play];
    [self.view addSubview:moviePlayer.view];
    
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
        
        // Dismiss the view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    NSLog(@"click");
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

@end
