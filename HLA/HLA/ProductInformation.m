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
    ColumnHeaderStyle *nama = [[ColumnHeaderStyle alloc]init:@"Nama Brosur" alignment:NSTextAlignmentCenter button:TRUE width:0.85];
    
    //add it to array
    columnHeadersContent = [NSArray arrayWithObjects:ilustrasi, nama, nil];
    tableManagement = [[TableManagement alloc]init:self.view themeColour:themeColour themeFont:fontType];
    TableHeader =[tableManagement TableHeaderSetupXY:columnHeadersContent
                                         positionY:80.0f positionX:80.0f];
    
    [self.view addSubview:TableHeader];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    NSArray *arrayOfData;
    if(row == 0)
        arrayOfData = [NSArray arrayWithObjects:@"1",@"Brochure Produk BCA LIfe Keluargaku",nil];
    [tableManagement TableRowInsert:arrayOfData index:indexPath.row table:cell color:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
    
    return cell;
}

- (IBAction)goHome:(id)sender{
    UIStoryboard *carouselStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
    CarouselViewController* carouselPage = [carouselStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
    [self presentViewController:carouselPage animated:YES completion:Nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self seePDF];
}

- (IBAction)seePDF{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Brochure_ProdukBCALIfeKeluargaku_21012016" ofType:@"pdf"];
    
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

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

@end
