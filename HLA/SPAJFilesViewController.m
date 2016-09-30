//
//  SPAJFilesViewController.m
//  BLESS
//
//  Created by Basvi on 8/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SPAJFilesViewController.h"
#import "Formatter.h"
#import "ProgressBar.h"
#import "ProgressBarDelegate.h"
#import "ModelSPAJTransaction.h"
#import "Alert.h"
#import "AppDelegate.h"
#import "ModelSPAJSubmitTracker.h"
#import "Alert.h"

@interface SPAJFilesViewController ()<ProgressBarDelegate>{
    ProgressBar *progressBar;
    
    IBOutlet UITableView* tableFileList;
    IBOutlet UIView* viewDisplay;
    IBOutlet UIImageView* imageViewDisplayImage;
    IBOutlet UIWebView* webViewDisplayPDF;
    IBOutlet UIScrollView* scrollImage;
    
    IBOutlet UIButton* buttonClose;
}

@end

@implementation SPAJFilesViewController{
    Formatter* formatter;
    ModelSPAJTransaction* modelSPAJTransaction;
    ModelSPAJSubmitTracker* modelSPAJSubmitTracker;
    Alert* alert;
    NSArray *directoryContent;
    NSMutableArray* arrayAfterSort;
    NSMutableArray* arrayFinalSort;
    
    int intUploadCount;
}
@synthesize dictTransaction;
@synthesize buttonSubmit;
@synthesize delegateSPAJFiles;
@synthesize boolHealthQuestionairre;

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, -10, 1024, 748);
    [self.view.superview setBackgroundColor:[UIColor clearColor]];
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadFilesList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[scrollImage setContentOffset:CGPointMake(scrollImage.contentOffset.x, 0) animated:YES];
    
    alert = [[Alert alloc]init];
    formatter = [[Formatter alloc]init];
    modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    modelSPAJSubmitTracker = [[ModelSPAJSubmitTracker alloc]init];
    alert = [[Alert alloc]init];
    intUploadCount = 0;
    
        // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFilesList{
    NSString* stringFilePath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
    int count;
    
    directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:stringFilePath error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    
    NSMutableArray* arrayBeforeSort = [[NSMutableArray alloc]initWithArray:directoryContent];
    
    arrayAfterSort = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[arrayBeforeSort count];i++){
        if ([[arrayBeforeSort objectAtIndex:i] rangeOfString:[dictTransaction valueForKey:@"SPAJSINO"]].location != NSNotFound) {
            [arrayAfterSort insertObject:[arrayBeforeSort objectAtIndex:i] atIndex:0];
        }
        else if ([[arrayBeforeSort objectAtIndex:i] rangeOfString:@"SPAJ"].location != NSNotFound){
            [arrayAfterSort insertObject:[arrayBeforeSort objectAtIndex:i] atIndex:1];
        }
        else{
            //[arrayAfterSort addObject:[arrayBeforeSort objectAtIndex:i]];
            [arrayAfterSort insertObject:[arrayBeforeSort objectAtIndex:i] atIndex:i];
        }
    }
    
    arrayFinalSort = [[NSMutableArray alloc]init];
    for (int i=0; i<[arrayAfterSort count];i++){
        if ([[arrayAfterSort objectAtIndex:i] rangeOfString:[dictTransaction valueForKey:@"SPAJSINO"]].location != NSNotFound) {
            [arrayFinalSort insertObject:[arrayAfterSort objectAtIndex:i] atIndex:0];
        }
        else if ([[arrayAfterSort objectAtIndex:i] rangeOfString:@"SPAJ"].location != NSNotFound){
            [arrayFinalSort insertObject:[arrayAfterSort objectAtIndex:i] atIndex:1];
        }
        else{
            //[arrayAfterSort addObject:[arrayBeforeSort objectAtIndex:i]];
            [arrayFinalSort insertObject:[arrayAfterSort objectAtIndex:i] atIndex:i];
        }
    }
    
    if (boolHealthQuestionairre){
        NSArray *extensions = [NSArray arrayWithObjects:@"jpg", nil];
        arrayFinalSort = [[arrayFinalSort filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", extensions]] mutableCopy];
    }
    
    [tableFileList reloadData];
}

-(void)showFileSelected:(int)indexSelected{
        [UIView animateWithDuration:0.3 animations:^{
            
            [tableFileList setFrame:CGRectMake(-tableFileList.frame.size.width, tableFileList.frame.origin.y, tableFileList.frame.size.width, tableFileList.frame.size.height)];
            [viewDisplay setFrame:CGRectMake(0, viewDisplay.frame.origin.y, viewDisplay.frame.size.width, viewDisplay.frame.size.height)];
            [buttonClose setTitle:@"Back" forState:UIControlStateNormal];
            [buttonClose setEnabled:false];
            [buttonSubmit setHidden:true];
        } completion:^ (BOOL completed) {
            [buttonClose setEnabled:true];
            [self voidLoadFile:indexSelected];
        }];
    
}

-(void)voidLoadFile:(int)arrayIndex{
    @try {
        //NSString* fileName = [directoryContent objectAtIndex:arrayIndex];
        NSString* fileName = [arrayFinalSort objectAtIndex:arrayIndex];
        //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName]];
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName]];
        NSString* fileType = [formatter findExtensionOfFileInUrl:url];
        [imageViewDisplayImage setImage:nil];
        [webViewDisplayPDF loadHTMLString:@"" baseURL:nil];
        if ([fileType isEqualToString:@"pdf"]){
            [webViewDisplayPDF setHidden:NO];
            [imageViewDisplayImage setHidden:YES];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webViewDisplayPDF loadRequest:request];
        }
        else{
            if ([fileName rangeOfString:@"page"].location == NSNotFound) {
                [scrollImage setZoomScale:0.0];
            }
            else{
                [scrollImage setZoomScale:4.0];
            }
            [webViewDisplayPDF setHidden:YES];
            [imageViewDisplayImage setHidden:NO];
            [imageViewDisplayImage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName]]];
            
            [self setCenter:nil];
            //[self scrollViewDidEndZooming:scrollImage withView:imageViewDisplayImage atScale:scrollImage.zoomScale];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}

-(IBAction)actionClose:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"Back"]){
        [UIView animateWithDuration:0.3 animations:^{
            [tableFileList setFrame:CGRectMake(0, tableFileList.frame.origin.y, tableFileList.frame.size.width, tableFileList.frame.size.height)];
            [viewDisplay setFrame:CGRectMake(viewDisplay.frame.size.width, viewDisplay.frame.origin.y, viewDisplay.frame.size.width, viewDisplay.frame.size.height)];
            [buttonClose setEnabled:false];
            [buttonClose setTitle:@"Close" forState:UIControlStateNormal];
        } completion:^ (BOOL completed) {
            [buttonClose setEnabled:true];
            [buttonSubmit setHidden:false];
            [imageViewDisplayImage setImage:nil];
            [webViewDisplayPDF loadHTMLString:@"" baseURL:nil];
        }];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(IBAction)actionSubmit:(UIButton *)sender{
    bool maximumReach = [modelSPAJSubmitTracker voidMaximumSubmitReached:[formatter getDateToday:@"yyyy-MM-dd"]];
    if (!maximumReach){
        [sender setEnabled:NO];
        NSString *serverURL = [NSString stringWithFormat:@"%@/Service2.svc/CreateRemoteFtpFolder?spajNumber=%@",[(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL], [dictTransaction valueForKey:@"SPAJNumber"]];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:serverURL]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    // handle response
                    if(data != nil){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [sender setEnabled:NO];
                            [self voidUploadFile];
                        });
                    }
                    else{
                        [sender setEnabled:YES];
                    }
                }] resume];
    }
    else{
        UIAlertController *alertLockForm = [alert alertInformation:@"Peringatan" stringMessage:@"Anda tidak dapat melakukan submission karena telah melebihi batas jumlah submit per hari"];
        [self presentViewController:alertLockForm animated:YES completion:nil];
    }
}

-(void)voidUploadFile{
    //NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *defaultDBPath = [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:@"hladb.sqlite"];
    NSString* fileName = [directoryContent objectAtIndex:intUploadCount];
    fileName = [NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName];
    NSBundle *myLibraryBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]
                                                         URLForResource:@"xibLibrary" withExtension:@"bundle"]];
    progressBar = [[ProgressBar alloc]initWithNibName:@"ProgressBar" bundle:myLibraryBundle];
    progressBar.TitleFileName = [NSString stringWithFormat: @"%@",[directoryContent objectAtIndex:intUploadCount]];
    progressBar.progressDelegate = self;
    progressBar.ftpfolderdestination = [dictTransaction valueForKey:@"SPAJNumber"];
    progressBar.ftpfiletoUpload = fileName;
    progressBar.ftpFunction = @"upload";
    progressBar.modalPresentationStyle = UIModalPresentationFormSheet;
    progressBar.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    progressBar.preferredContentSize = CGSizeMake(600, 200);
    [self presentViewController:progressBar animated:YES completion:nil];
}

#pragma mark delegate
- (void)downloadisFinished{
    intUploadCount = intUploadCount + 1;
    if (intUploadCount == [directoryContent count]){
        intUploadCount = 0;
        
        NSString* stringSPAJNumber=[dictTransaction valueForKey:@"SPAJNumber"];
        NSString* stringProductName=[dictTransaction valueForKey:@"ProductName"];
        NSString* stringPemegangPolis=[dictTransaction valueForKey:@"ProspectName"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/Service2.svc/UpdateOnPostUploadData?spajNumber=%@&producName=%@&polisOwner=%@", [(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL], stringSPAJNumber,stringProductName,stringPemegangPolis];

        
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:urlStr]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    // handle response
                    if(data != nil){
                        NSMutableDictionary* json = [NSJSONSerialization
                                                     JSONObjectWithData:data //1
                                                     options:NSJSONReadingMutableContainers
                                                     error:&error];
                        NSLog(@"%@", json);
                        [buttonSubmit setEnabled:YES];
                        [modelSPAJTransaction updateSPAJTransaction:@"SPAJStatus" StringColumnValue:@"Submitted" StringWhereName:@"SPAJEappNumber" StringWhereValue:[dictTransaction valueForKey:@"SPAJEappNumber"]];
                        
                        [modelSPAJSubmitTracker saveSPAJSubmitDate:[dictTransaction valueForKey:@"SPAJNumber"] SubmitDate:[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"]];
                        [progressBar dismissViewControllerAnimated:YES completion:nil];
                        
                        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Sukses Upload" message:@"Data berhasil diupload" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            //[progressBar dismissViewControllerAnimated:YES completion:^{}];
                            [self dismissViewControllerAnimated:YES completion:^{[delegateSPAJFiles loadSPAJTransaction];}];
                        }]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }] resume];
    }
    else{
        [progressBar dismissViewControllerAnimated:YES completion:^{
            [self voidUploadFile];
        }];
    }
}

- (void)percentCompletedfromFTP:(float)percent{
    //left this blank
}

- (void)downloadisError{
    [progressBar dismissViewControllerAnimated:YES completion:nil];
    UIAlertController* alertError = [UIAlertController alertControllerWithTitle:@"Koneksi ke FTP Gagal" message:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertError animated:YES completion:nil];
    //UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Koneksi ke FTP Gagal" message:[NSString stringWithFormat:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //[alert show];
    [buttonSubmit setEnabled:YES];
}

- (void)failedConnectToFTP{
    [progressBar dismissViewControllerAnimated:YES completion:nil];
    UIAlertController* alertError = [UIAlertController alertControllerWithTitle:@"Koneksi ke FTP Gagal" message:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertError animated:YES completion:nil];
    //UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Koneksi ke FTP Gagal" message:[NSString stringWithFormat:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //[alert show];
    [buttonSubmit setEnabled:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [directoryContent count];
    return [arrayFinalSort count];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //[cell.textLabel setText:[directoryContent objectAtIndex:indexPath.row]];
    [cell.textLabel setText:[arrayFinalSort objectAtIndex:indexPath.row]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"BPReplay" size:17.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showFileSelected:indexPath.row];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageViewDisplayImage;
}

-(IBAction)setCenter:(UIButton *)sender{
    CGSize imgViewSize = imageViewDisplayImage.frame.size;
    CGSize imageSize = imageViewDisplayImage.image.size;
    
    CGSize realImgSize;
    if(imageSize.width / imageSize.height > imgViewSize.width / imgViewSize.height) {
        realImgSize = CGSizeMake(imgViewSize.width, imgViewSize.width / imageSize.width * imageSize.height);
    }
    else {
        realImgSize = CGSizeMake(imgViewSize.height / imageSize.height * imageSize.width, imgViewSize.height);
    }
    
    CGRect fr = CGRectMake(0, 0, 0, 0);
    fr.size = realImgSize;
    imageViewDisplayImage.frame = fr;
    
    CGSize scrSize = scrollImage.frame.size;
    float offx = (scrSize.width > realImgSize.width ? (scrSize.width - realImgSize.width) / 2 : 0);
    //float offy = (scrSize.height > realImgSize.height ? (scrSize.height - realImgSize.height) / 2 : 0);
    //[UIView beginAnimations:nil context:nil];
    //[UIView setAnimationDuration:0.25];
    //scrollImage.contentInset = UIEdgeInsetsMake(offy, offx, offy, offx);
    scrollImage.contentInset = UIEdgeInsetsMake(0, offx, 0, offx);
    [scrollImage setContentOffset:CGPointMake(-offx, 0)];
    [scrollImage setContentSize:CGSizeMake(imageViewDisplayImage.frame.size.width, imageViewDisplayImage.frame.size.height)];
    //[UIView commitAnimations];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)view atScale:(float)scale {
    CGSize imgViewSize = imageViewDisplayImage.frame.size;
    CGSize imageSize = imageViewDisplayImage.image.size;
    
    CGSize realImgSize;
    if(imageSize.width / imageSize.height > imgViewSize.width / imgViewSize.height) {
        realImgSize = CGSizeMake(imgViewSize.width, imgViewSize.width / imageSize.width * imageSize.height);
    }
    else {
        realImgSize = CGSizeMake(imgViewSize.height / imageSize.height * imageSize.width, imgViewSize.height);
    }
    
    CGRect fr = CGRectMake(0, 0, 0, 0);
    fr.size = realImgSize;
    imageViewDisplayImage.frame = fr;
    
    CGSize scrSize = scrollImage.frame.size;
    float offx = (scrSize.width > realImgSize.width ? (scrSize.width - realImgSize.width) / 2 : 0);
    float offy = (scrSize.height > realImgSize.height ? (scrSize.height - realImgSize.height) / 2 : 0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    scrollImage.contentInset = UIEdgeInsetsMake(offy, offx, offy, offx);
    [UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    /*CGPoint contentOffset = CGPointMake(0, sender.contentOffset.y);
    [sender setContentOffset:contentOffset];*/
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)sender{
    NSLog(@"inset %@",NSStringFromUIEdgeInsets(sender.contentInset));
    NSLog(@"offset %@",NSStringFromCGPoint(sender.contentOffset));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"inset %@",NSStringFromUIEdgeInsets(scrollView.contentInset));
    NSLog(@"offset %@",NSStringFromCGPoint(scrollView.contentOffset));
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
