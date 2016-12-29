//
//  SIDate.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/4/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIDate.h"

@interface SIDate ()<UITextFieldDelegate>

@end

@implementation SIDate
@synthesize outletDate = _outletDate;
@synthesize delegate = _delegate;
@synthesize ProspectDOB;

id msg, DBDate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    if ((ProspectDOB != NULL)&&(![ProspectDOB isEqual:@"(null)"])) {
        @try {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
            //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *zzz = [dateFormatter dateFromString:ProspectDOB];
            [_outletDate setDate:zzz animated:YES ];
            msg = ProspectDOB;
            [self setTextFieldDates];
        }
        @catch (NSException *exception) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //[dateFormatter setDateFormat:@"dd/MM/yyyy"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *zzz = [dateFormatter dateFromString:ProspectDOB];
            [_outletDate setDate:zzz animated:YES ];
            
            [self setTextFieldDates];

        }
        @finally {
            NSLog(@"succeded");
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    formatter = [[Formatter alloc]init];
    
    [_outletTextMonth setDelegate:self];
    [_outletTextDay setDelegate:self];
    
    msg = @"";
    DBDate = @"";
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    msg = dateString;
  
    
    if ((ProspectDOB != NULL)&&(![ProspectDOB isEqual:@"(null)"])) {
        @try {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
            //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *zzz = [dateFormatter dateFromString:ProspectDOB];
            [_outletDate setDate:zzz animated:YES ];
        }
        @catch (NSException *exception) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //[dateFormatter setDateFormat:@"dd/MM/yyyy"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *zzz = [dateFormatter dateFromString:ProspectDOB];
            [_outletDate setDate:zzz animated:YES ];
        }
        @finally {
            NSLog(@"berhasil");
        }
    }
}

- (void)viewDidUnload
{
    [self setOutletDate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _outletTextMonth){
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        //first, check if the new string is numeric only. If not, return NO;
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789,."] invertedSet];
        if ([newString rangeOfCharacterFromSet:characterSet].location != NSNotFound)
        {
            return NO;
        }
        
        return [newString doubleValue] < 13;
    }
    else if (textField == _outletTextDay){
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        //first, check if the new string is numeric only. If not, return NO;
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789,."] invertedSet];
        if ([newString rangeOfCharacterFromSet:characterSet].location != NSNotFound)
        {
            return NO;
        }
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate* dateSelected = [formatter DateFromString:[NSString stringWithFormat:@"1/%@/%@",_outletTextMonth.text,_outletTextYear.text] DateFormat:@"dd/MM/yyyy"];
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateSelected];
        NSUInteger numberOfDaysInMonth = range.length;
        return [newString doubleValue] <= numberOfDaysInMonth;
    }
}


-(IBAction)textChanged:(UITextField *)sender{
    @try {
        if (sender == _outletTextYear){
            if ([sender.text length]==4){
                NSString* date = [NSString stringWithFormat:@"%@/%@/%@",_outletTextDay.text,_outletTextMonth.text,_outletTextYear.text];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                NSDate *zzz = [dateFormatter dateFromString:date];
                [_outletDate setDate:zzz animated:YES ];
                
                NSString *pickerDate = [dateFormatter stringFromDate:[_outletDate date]];
                msg = [NSString stringWithFormat:@"%@",pickerDate];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                DBDate = [dateFormatter stringFromDate:[_outletDate date]];
            }
        }
        else{
            if ([sender.text length]>0){
                NSString* date = [NSString stringWithFormat:@"%@/%@/%@",_outletTextDay.text,_outletTextMonth.text,_outletTextYear.text];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                NSDate *zzz = [dateFormatter dateFromString:date];
                [_outletDate setDate:zzz animated:YES ];
                
                NSString *pickerDate = [dateFormatter stringFromDate:[_outletDate date]];
                msg = [NSString stringWithFormat:@"%@",pickerDate];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                DBDate = [dateFormatter stringFromDate:[_outletDate date]];
            }
        }
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

-(void)setTextFieldDates{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[_outletDate date]]; // Get necessary date components
    
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    [_outletTextDay setText:[NSString stringWithFormat:@"%ld",(long)day]];
    [_outletTextMonth setText:[NSString stringWithFormat:@"%ld",(long)month]];
    [_outletTextYear setText:[NSString stringWithFormat:@"%ld",(long)year]];
}

- (IBAction)ActionDate:(id)sender {
    if (_delegate != Nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        NSString *pickerDate = [dateFormatter stringFromDate:[_outletDate date]];
        
        msg = [NSString stringWithFormat:@"%@",pickerDate];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        DBDate = [dateFormatter stringFromDate:[_outletDate date]];
        //[_delegate DateSelected:msg :DBDate];
        
        [self setTextFieldDates];
    }
}
- (IBAction)btnClose:(id)sender {
    [_delegate CloseWindow];
}

- (IBAction)btnDone:(id)sender {
   
    if (msg == NULL) {
        
        // if msg = null means user din rotate the date...and choose the default date value
        NSDateFormatter *formatter;
        NSString        *dateString;
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        
        dateString = [formatter stringFromDate:[NSDate date]];
        msg = dateString;
        
          [_delegate DateSelected:msg :DBDate];
    }
    else{
        
         
         [_delegate DateSelected:msg :DBDate];
    }
    
    
    
    
    [_delegate CloseWindow];
}
@end
