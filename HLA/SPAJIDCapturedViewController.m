//
//  SPAJIDCapturedViewController.m
//  BLESS
//
//  Created by Basvi on 8/19/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//
NSString* const PaymentSection = @"Payment";
NSString* const OtherSection = @"Other";
NSString* const FrontPhoto = @"Front";
NSString* const BackPhoto = @"Back";

#import "SPAJIDCapturedViewController.h"

@interface SPAJIDCapturedViewController (){
    NSMutableArray* arrayAllImage;
}

@end

@implementation SPAJIDCapturedViewController
@synthesize dictionaryIDData,dictTransaction;
@synthesize imageFront,imageBack;
@synthesize partyIndex;
@synthesize buttonTitle;

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 587, 600);
    [self.view.superview setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    formatter = [[Formatter alloc]init];
    
    [self loadIDInformation];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadIDInformation{
    NSString* IDType  = [dictionaryIDData valueForKey:@"IDType"];
    NSString* stringName = [dictionaryIDData valueForKey:@"stringName"];
    [labelIDDesc setText:IDType];
    [labelName setText:stringName];
    if ([partyIndex intValue]==4){
        [tableImageCaptured setHidden:NO];
        //[self showMultiplePictureForSection:PaymentSection StringButtonType:buttonTitle];
        [self showMultiplePictureForSection:OtherSection StringButtonType:buttonTitle];
    }
    /*else if ([partyIndex intValue]==5){
        [tableImageCaptured setHidden:NO];
        [self showMultiplePictureForSection:OtherSection StringButtonType:buttonTitle];
    }*/
    else if ([partyIndex intValue]==3){
        [tableImageCaptured setHidden:NO];
        //[self showMultiplePictureForSection:OtherSection StringButtonType:buttonTitle];
        [self showMultiplePictureForSection:PaymentSection StringButtonType:buttonTitle];
    }
    else{
        [imageViewFront setImage:imageFront];
        [imageViewBack setImage:imageBack];
        [tableImageCaptured setHidden:YES];
    }
}


-(void)showMultiplePictureForSection:(NSString *)stringSection StringButtonType:(NSString *)stringButtonType{
    NSString* stringEAPPPath = [dictTransaction valueForKey:@"SPAJEappNumber"];
    NSString* fileNameFront;
    NSString* fileNameBack;
    fileNameFront=[NSString stringWithFormat:@"%@_%@_%@_%@",stringEAPPPath,stringSection,stringButtonType?:@"",FrontPhoto];
    fileNameBack=[NSString stringWithFormat:@"%@_%@_%@_%@",stringEAPPPath,stringSection,stringButtonType?:@"",BackPhoto];
    
    NSArray* arrayImageFront=[[NSArray alloc]initWithArray:[self loadFilesList:fileNameFront]];
    NSArray* arrayImageBack=[[NSArray alloc]initWithArray:[self loadFilesList:fileNameBack]];
    
    arrayAllImage = [[NSMutableArray alloc]initWithArray:arrayImageFront];
    [arrayAllImage addObjectsFromArray:arrayImageBack];

    [tableImageCaptured reloadData];
}

-(UIView *)viewIDImage:(int)imageIndex StringImageName:(NSString *)stringImage{
    NSString* fileName = stringImage;
    UIView* viewParent;
    [viewParent setFrame:CGRectMake(0, imageIndex*283, 398, 283)];
    
    UILabel* labelImageName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 398, 50)];
    UIImageView* imageViewID = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 398, 233)];
    
    [labelImageName setText:fileName];
    [imageViewID setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName]]];
    
    [viewParent addSubview:labelImageName];
    [viewParent addSubview:imageViewID];
    [viewParent setBackgroundColor:[UIColor redColor]];
    return viewParent;
}

- (NSArray *)loadFilesList:(NSString *)fileName{
    //NSString* stringFilePath = fileName;
    formatter = [[Formatter alloc]init];
    NSString* stringFilePath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
    
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF contains[c] '%@'",fileName]];
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:stringFilePath error:NULL];
    NSMutableArray* arrayFileContent = [[NSMutableArray alloc]initWithArray:directoryContent];
    
    [arrayFileContent filterUsingPredicate:sPredicate];
    for (count = 0; count < (int)[arrayFileContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [arrayFileContent objectAtIndex:count]);
    }
    return arrayFileContent;
}


-(IBAction)actionClose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayAllImage count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MultipleImageIDTableViewCell *cellMultipleID = (MultipleImageIDTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MultipleImageIDTableViewCell"];
    
    if (cellMultipleID == nil)
    {
        NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"MultipleImageIDTableViewCell" owner:self options:nil];
        cellMultipleID = [arrayNIB objectAtIndex:0];
    }
    else
    {
        
    }
    
    if (indexPath.row<[arrayAllImage count]){
        [cellMultipleID.labelFileName setText:[arrayAllImage objectAtIndex:indexPath.row]];
        [cellMultipleID.imageViewFile setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],[arrayAllImage objectAtIndex:indexPath.row]]]];
    }
    return cellMultipleID;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
