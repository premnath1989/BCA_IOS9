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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Brochures"];
    
    [self createDirectory];
    
    //we test our ftp
    FTPItemsList = [[NSMutableArray alloc]init];
    [FTPItemsList addObject:[NSMutableArray arrayWithObjects:@"1",@"Brochure_ProdukBCALIfeKeluargaku_21012016", @"brosur",@"10mb",@"",nil]];
    [FTPItemsList addObject:[NSMutableArray arrayWithObjects:@"2",@"BCA_life_Keluargaku_Video_Testimonial_Part_I_final", @"video",@"10mb",@"", nil]];
    
    
    FTPitems = [[ProductInfoItems alloc]init];
    [FTPitems listDirectory];
    FTPitems.ftpDelegate = self;
    
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
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:filePath
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
    ColumnHeaderStyle *nama = [[ColumnHeaderStyle alloc]init:@"Nama" alignment:NSTextAlignmentCenter button:TRUE width:0.60];
    ColumnHeaderStyle *type = [[ColumnHeaderStyle alloc]init:@"Kategori" alignment:NSTextAlignmentCenter button:TRUE width:0.15];
    ColumnHeaderStyle *size = [[ColumnHeaderStyle alloc]init:@"Ukuran" alignment:NSTextAlignmentCenter button:TRUE width:0.10];
    ColumnHeaderStyle *download = [[ColumnHeaderStyle alloc]init:@"Unduh" alignment:NSTextAlignmentCenter button:TRUE width:0.10];
    
    //add it to array
    columnHeadersContent = [NSArray arrayWithObjects:ilustrasi, nama, type, size, download, nil];
    tableManagement = [[TableManagement alloc]init:self.view themeColour:themeColour themeFont:fontType];
    TableHeader =[tableManagement TableHeaderSetupXY:columnHeadersContent
                                         positionY:80.0f positionX:80.0f];
    
    [self.view addSubview:TableHeader];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section {
    return [FTPItemsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }else{
        for (UIView* textLabel in cell.contentView.subviews)
        {
            [textLabel removeFromSuperview];
        }
    }
    NSLog(@"insert : %d",indexPath.row);
    
    if([FTPItemsList count] != 0){
        NSMutableArray *itemCell =  [FTPItemsList objectAtIndex:indexPath.row];
        NSString *FileName = [itemCell objectAtIndex:1];
        NSString *FileType = [itemCell objectAtIndex:2];
        
        if([FileType caseInsensitiveCompare:@"brosur"] == NSOrderedSame){
            FileName = [NSString stringWithFormat: @"%@.%@",FileName, @"pdf"];
        }else if([FileType caseInsensitiveCompare:@"video"] == NSOrderedSame){
            FileName = [NSString stringWithFormat: @"%@.%@",FileName, @"mp4"];
        }
        
        //simply we check whether the file exist in brochure folder or not.
        if (![[NSFileManager defaultManager] fileExistsAtPath:
              [NSString stringWithFormat:@"%@/%@",filePath,FileName]]){
            [[FTPItemsList objectAtIndex:indexPath.row] replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"unduh"]];
        }
    }
    
    [tableManagement TableRowInsert:[FTPItemsList objectAtIndex:indexPath.row] index:indexPath.row table:cell color:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
    
    return cell;
}

- (IBAction)goHome:(id)sender{
    UIStoryboard *carouselStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
    CarouselViewController* carouselPage = [carouselStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
    [self presentViewController:carouselPage animated:YES completion:Nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"click : %d",indexPath.row);
    UILabel *fileName = (UILabel *)[cell.contentView viewWithTag:(indexPath.row*1000)+1];
    UILabel *fileType = (UILabel *)[cell viewWithTag:(indexPath.row*1000)+2];
    UILabel *unduhLabel = (UILabel *)[cell viewWithTag:(indexPath.row*1000)+4];
    NSLog(@"file : %@.%@", fileName.text,fileType.text);
    
    if([fileType.text caseInsensitiveCompare:@"brosur"] == NSOrderedSame){
        if([unduhLabel.text caseInsensitiveCompare:@"unduh"] == NSOrderedSame){
            [FTPitems downloadFile:[NSString stringWithFormat: @"%@.%@",fileName.text, @"pdf"]];
        }else{
            [self seePDF:[NSString stringWithFormat: @"%@.%@",fileName.text, @"pdf"]];
        }
    }else if([fileType.text caseInsensitiveCompare:@"video"] == NSOrderedSame){
        if([unduhLabel.text caseInsensitiveCompare:@"unduh"] == NSOrderedSame){
            [FTPitems downloadFile:[NSString stringWithFormat: @"%@.%@",fileName.text, @"mp4"]];
        }else{
            [self seeVideo:[NSString stringWithFormat: @"%@.%@",fileName.text, @"mp4"]];
        }
    }
}

- (IBAction)seePDF:(NSString *)fileName{
    NSString *file = [NSString stringWithFormat: @"%@/%@",filePath, fileName];
    
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
    NSString*thePath=[NSString stringWithFormat: @"%@/%@",filePath, fileName];
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

- (void)reloadItemsTable{
    [myTableView reloadData];
}

- (void)itemsList:(NSMutableArray *)ftpItems{
    NSLog(@"ftp itemlist");
    int index = 1;
    [FTPItemsList removeAllObjects];
    for(NSMutableDictionary *itemInfo in ftpItems){
        for(NSString *key in [itemInfo allKeys]){
            NSArray* fullFileName = [key componentsSeparatedByString: @"."];
            NSString *fileName = [fullFileName objectAtIndex:0];
            NSString *fileExt = [fullFileName objectAtIndex:1];
            NSString *fileSize = [NSByteCountFormatter stringFromByteCount:[[itemInfo objectForKey:key] longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
            NSString *fileFormat = @"";
            NSString *fileExist = @"";
            if([fileExt caseInsensitiveCompare:@"mp4"] == NSOrderedSame){
                fileFormat = @"video";
            }else if([fileExt caseInsensitiveCompare:@"pdf"] == NSOrderedSame){
                fileFormat = @"brosur";
            }
            
            [FTPItemsList addObject:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",index],fileName, fileFormat,fileSize,fileExist,nil]];
            index++;
        }
    }
    [myTableView reloadData];
}

@end
