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
@interface SPAJFilesViewController ()<ProgressBarDelegate>{
    ProgressBar *progressBar;
    
    IBOutlet UITableView* tableFileList;
    IBOutlet UIView* viewDisplay;
    IBOutlet UIImageView* imageViewDisplayImage;
    IBOutlet UIWebView* webViewDisplayPDF;
    
    IBOutlet UIButton* buttonClose;
    IBOutlet UIButton* buttonSubmit;
}

@end

@implementation SPAJFilesViewController{
    Formatter* formatter;
    NSArray *directoryContent;
    
    int intUploadCount;
}
@synthesize dictTransaction;

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 600, 600);
    [self.view.superview setBackgroundColor:[UIColor whiteColor]];
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadFilesList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    formatter = [[Formatter alloc]init];
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
    NSString* fileName = [directoryContent objectAtIndex:arrayIndex];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName]];
    
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
        [webViewDisplayPDF setHidden:YES];
        [imageViewDisplayImage setHidden:NO];
        
        [imageViewDisplayImage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName]]];
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
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://mposws.azurewebsites.net/Service2.svc/CreateRemoteFtpFolder?spajNumber=60000000009"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if(data != nil){
                    [self voidUploadFile];
                }
            }] resume];

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
        NSString* stringSPAJNumber=[dictTransaction valueForKey:@"SPAJNumber"];
        NSString* stringProductName=[dictTransaction valueForKey:@"ProductName"];
        NSString* stringPemegangPolis=[dictTransaction valueForKey:@"ProspectName"];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://mposws.azurewebsites.net/Service2.svc/UpdateOnPostUploadData?spajNumber=%@&producName=%@&polisOwner=%@",stringSPAJNumber,stringProductName,stringPemegangPolis];
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
                        [progressBar dismissViewControllerAnimated:YES completion:^{}];
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
    /*UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Koneksi ke FTP Gagal" message:[NSString stringWithFormat:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];*/
}

- (void)failedConnectToFTP{
    /*UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Koneksi ke FTP Gagal" message:[NSString stringWithFormat:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];*/
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [directoryContent count];
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
    
    [cell.textLabel setText:[directoryContent objectAtIndex:indexPath.row]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"BPReplay" size:17.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showFileSelected:indexPath.row];
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
