//
//  HealthQuestionnaire7.m
//  iMobile Planner
//
//  Created by Erza on 7/29/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "HealthQuestionnaire7.h"
#import "DataClass.h" 
#import "ColorHexCode.h"
#import <QuartzCore/QuartzCore.h>

@interface HealthQuestionnaire7 ()

{
    DataClass *obj;
}

@end

@implementation HealthQuestionnaire7

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     obj = [DataClass getInstance];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //Display data from obj
	
	tohq7 = [TagObject tagObj];
	
	_textField.delegate = self;
	
    NSString* text = [[obj.eAppData objectForKey:@"SecE"] objectForKey:@"Q7"];
    
    if(text != NULL || ![text isEqualToString:@""])
        //self.textField.text = text;
        self.textView.text = text;
    
    [[self.textView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.textView layer] setBorderWidth:1.0];
    [[self.textView layer] setCornerRadius:0.1];
	
	[_textField addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	tohq7.fd7 = textField.text;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    tohq7.fd7 = textView.text;
    NSLog(@"tohq %@",textView.text);
    [[obj.eAppData objectForKey:@"EAPP"] setValue:@"1" forKey:@"EAPPSave"];
    NSLog(@"detect changes");
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

	NSUInteger newLength = [textField.text length] + [string length] - range.length;
		return ((newLength <= 250));
	
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    if (textView == _textView)
    {
        
		NSUInteger newLength = [textView.text length] + [text length] - range.length;
        
		return ((newLength <= 250));
	}
    return TRUE;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,400,44)];
	tempView.backgroundColor=[UIColor clearColor];
	
	ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
	UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(60,0,400,44)];
	tempLabel.backgroundColor = [UIColor clearColor];
	tempLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:18];
    tempLabel.font = [UIFont boldSystemFontOfSize:18];
    tempLabel.textColor = [CustomColor colorWithHexString:@"234A7D"];
	
	//tempLabel.text=@"1st Life Assured";
	obj = [DataClass getInstance];
	tempLabel.text = [[obj.eAppData objectForKey:@"SecE"] objectForKey:@"PersonType"];
	[tempView addSubview:tempLabel];
	
	return tempView;
}

-(void)detectChanges:(id) sender
{
    [[obj.eAppData objectForKey:@"EAPP"] setValue:@"1" forKey:@"EAPPSave"];
}


- (void)viewDidUnload {
    [self setTextField:nil];
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
