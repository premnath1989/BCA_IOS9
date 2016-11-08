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
#import "Reachability.h"
#import "ProgressBar.h"
#import "ChangePassword.h"
#import "UIView+viewRecursion.h"

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
    
    [self directoryFileListing];
    
    if([self connected]){
        
        UIView *spinnerHolder = [[UIView alloc]initWithFrame:CGRectMake(150, 80, 500, 500)];
        spinnerHolder.tag = 501;
        [self.view addSubview:spinnerHolder];
        
        spinnerLoading = [[SpinnerUtilities alloc]init];
        [spinnerLoading startLoadingSpinner:spinnerHolder label:@"Loading Informasi Produk"];
        [self FTPFileListing];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Koneksi ke FTP Gagal" message:[NSString stringWithFormat:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] init];
    [newAttributes setObject:[UIFont systemFontOfSize:18] forKey:UITextAttributeFont];
    [self.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                 [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextShadowColor,
                                                 [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                 [UIFont fontWithName:@"BPreplay" size:18.0], UITextAttributeFont,
                                                 nil] ];
    
    themeColour = [UIColor colorWithRed:0.0f/255.0f green:160.0f/255.0f blue:180.0f/255.0f alpha:1];
    fontType = [UIFont fontWithName:@"BPreplay" size:16.0f];
    
    [self setupTableColumn];
    
    [btnHome addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


- (void)FTPFileListing{
    FTPitems = [[ProductInfoItems alloc]init];
    [FTPitems listDirectory];
    FTPitems.ftpDelegate = self;
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

- (void)directoryFileListing{
    
    FTPItemsList = [[NSMutableArray alloc]init];
    NSURL *directoryURL = [NSURL fileURLWithPath:filePath
                                     isDirectory:YES];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *contentsError = nil;
    NSArray *contents = [fm contentsOfDirectoryAtURL:directoryURL
                          includingPropertiesForKeys:@[NSURLFileSizeKey, NSURLIsDirectoryKey]
                                             options:0
                                               error:&contentsError];
    
    int index = 1;
    for (NSURL *fileURL in contents) {
        // Enumerate each file in directory
        NSNumber *fileSizeNumber = nil;
        NSError *sizeError = nil;
        [fileURL getResourceValue:&fileSizeNumber
                              forKey:NSURLFileSizeKey
                               error:&sizeError];
        
        [self insertIntoTableData:[fileURL lastPathComponent] size:[fileSizeNumber stringValue] index:index];
        index++;
    }
    [spinnerLoading stopLoadingSpinner];
    for(UIView *v in [self.view allSubViews]){
        if(v.tag == 501)
            v.hidden = YES;
    }
}

- (void)setupTableColumn{
    //we call the table management to design the table
    ColumnHeaderStyle *ilustrasi = [[ColumnHeaderStyle alloc]init:@" No. " alignment:NSTextAlignmentLeft button:FALSE width:0.05];
    ColumnHeaderStyle *nama = [[ColumnHeaderStyle alloc]init:@"Nama" alignment:NSTextAlignmentCenter button:TRUE width:0.60];
    ColumnHeaderStyle *type = [[ColumnHeaderStyle alloc]init:@"Kategori" alignment:NSTextAlignmentCenter button:TRUE width:0.15];
    ColumnHeaderStyle *size = [[ColumnHeaderStyle alloc]init:@"Ukuran" alignment:NSTextAlignmentCenter button:TRUE width:0.10];
    ColumnHeaderStyle *download = [[ColumnHeaderStyle alloc]init:downloadMacro alignment:NSTextAlignmentCenter button:TRUE width:0.10];
    
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
        
        if([FileType caseInsensitiveCompare:brochureLabel] == NSOrderedSame){
            FileName = [NSString stringWithFormat: @"%@.%@",FileName, brochureExt];
        }else if([FileType caseInsensitiveCompare:videoLabel] == NSOrderedSame){
            FileName = [NSString stringWithFormat: @"%@.%@",FileName, videoExt];
        }
        
        //simply we check whether the file exist in brochure folder or not.
        if ([[NSFileManager defaultManager] fileExistsAtPath:
              [NSString stringWithFormat:@"%@/%@",filePath,FileName]]){
            [[FTPItemsList objectAtIndex:indexPath.row] replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@""]];
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
    
    NSBundle *myLibraryBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]
                                                         URLForResource:@"xibLibrary" withExtension:@"bundle"]];
    
    if([fileType.text caseInsensitiveCompare:brochureLabel] == NSOrderedSame){
        if([unduhLabel.text caseInsensitiveCompare:downloadMacro] == NSOrderedSame){
            
            ProgressBar *progressBar = [[ProgressBar alloc]initWithNibName:@"ProgressBar" bundle:myLibraryBundle];
            progressBar.TitleFileName = [NSString stringWithFormat: @"%@.%@",fileName.text, brochureExt];
            progressBar.progressDelegate = self;
            progressBar.modalPresentationStyle = UIModalPresentationFormSheet;
            progressBar.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            progressBar.preferredContentSize = CGSizeMake(600, 200);
            progressBar.ftpFunction = @"download";
            [self presentViewController:progressBar animated:YES completion:nil];
            
        }else{
            [self seePDF:[NSString stringWithFormat: @"%@.%@",fileName.text, brochureExt]];
        }
    }else if([fileType.text caseInsensitiveCompare:videoLabel] == NSOrderedSame){
        if([unduhLabel.text caseInsensitiveCompare:downloadMacro] == NSOrderedSame){
            
            ProgressBar *progressBar = [[ProgressBar alloc]initWithNibName:@"ProgressBar" bundle:myLibraryBundle];
            progressBar.TitleFileName = [NSString stringWithFormat: @"%@.%@",fileName.text, videoExt];
            progressBar.progressDelegate = self;
            progressBar.modalPresentationStyle = UIModalPresentationFormSheet;
            progressBar.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            progressBar.preferredContentSize = CGSizeMake(600, 200);
            progressBar.ftpFunction = @"download";
            [self presentViewController:progressBar animated:YES completion:nil];
        }else{
            [self seeVideo:[NSString stringWithFormat: @"%@.%@",fileName.text, videoExt]];
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
        BOOL illustrationSigned = 1;
        readerViewController.illustrationSignature = illustrationSigned;
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

//for brochure
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)itemsList:(NSMutableArray *)ftpItems{
    NSLog(@"ftp itemlist");
    int index = 1;
    
    //we remove any files if local if not listed in FTP
    [self removeLocalFiles:ftpItems];
    
    [FTPItemsList removeAllObjects];
    for(NSMutableDictionary *itemInfo in ftpItems){
        for(NSString *key in [itemInfo allKeys]){
            [self insertIntoTableData:key size:[itemInfo objectForKey:key] index:index];
            index++;
        }
    }
    [myTableView reloadData];
}

- (void)removeLocalFiles:(NSMutableArray *)ftpItems{
    for(NSMutableArray *itemCell in FTPItemsList){
        NSString *FileName = [itemCell objectAtIndex:1];
        NSString *FileType = [itemCell objectAtIndex:2];
        
        if([FileType caseInsensitiveCompare:brochureLabel] == NSOrderedSame){
            FileName = [NSString stringWithFormat: @"%@.%@",FileName, brochureExt];
        }else if([FileType caseInsensitiveCompare:videoLabel] == NSOrderedSame){
            FileName = [NSString stringWithFormat: @"%@.%@",FileName, videoExt];
        }
        
        BOOL exist = FALSE;
        for(NSMutableDictionary *itemInfo in ftpItems){
            for(NSString *key in [itemInfo allKeys]){
                if([key caseInsensitiveCompare:FileName] == NSOrderedSame){
                    exist = TRUE;
                }
            }
        }
        
        //after checking, if the files not listed in FTP. we delete the file in local.
        if(!exist){
            NSError *error = nil;
            if ([[NSFileManager defaultManager] removeItemAtPath:
                 [NSString stringWithFormat:@"%@/%@",filePath,FileName] error:&error]){
            }
        }
    }
}

- (void)insertIntoTableData:(NSString *)fileNameParam size:(NSString *)fileSizeParam index:(int)fileIndex{
    NSArray* fullFileNameTemp = [fileNameParam componentsSeparatedByString: @"."];
    NSString *fileName = [fullFileNameTemp objectAtIndex:0];
    NSString *fileExt = [fullFileNameTemp objectAtIndex:1];
    NSString *fileSize = [NSByteCountFormatter stringFromByteCount:[fileSizeParam longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
    NSString *fileFormat = @"";
    NSString *fileExist = downloadMacro;
    if([fileExt caseInsensitiveCompare:videoExt] == NSOrderedSame){
        fileFormat = videoLabel;
    }else if([fileExt caseInsensitiveCompare:brochureExt] == NSOrderedSame){
        fileFormat = brochureLabel;
    }
    
    [FTPItemsList addObject:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",fileIndex],fileName, fileFormat,fileSize,fileExist,nil]];
    
    [spinnerLoading stopLoadingSpinner];
    for(UIView *v in [self.view allSubViews]){
        if(v.tag == 501)
            v.hidden = YES;
    }
}

- (void)downloadisFinished{
    [myTableView reloadData];
}

- (void)percentCompletedfromFTP:(float)percent{
    //left this blank
}

- (void)downloadisError{
    [spinnerLoading stopLoadingSpinner];
    for(UIView *v in [self.view allSubViews]){
        if(v.tag == 501)
            v.hidden = YES;
    }
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Koneksi ke FTP Gagal" message:[NSString stringWithFormat:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)failedConnectToFTP{
    [spinnerLoading stopLoadingSpinner];
    for(UIView *v in [self.view allSubViews]){
        if(v.tag == 501)
            v.hidden = YES;
    }
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Koneksi ke FTP Gagal" message:[NSString stringWithFormat:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
