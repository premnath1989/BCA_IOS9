//
//  DateViewController.m
//  HLA
//
//  Created by shawal sapuan on 9/25/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController
@synthesize datePickerView = _datePickerView;
@synthesize msgDate,msgAge,selectedStrDate,selectedStrAge,Age,ANB,btnSender;
@synthesize delegate = _delegate;

id msg, ComDate;

-(void)viewDidAppear:(BOOL)animated{
    if ((msgDate != NULL)&&(![msgDate isEqualToString:@"--Please Select--"])) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *zzz = [dateFormatter dateFromString:msgDate];
        [_datePickerView setDate:zzz animated:YES ];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ((msgDate != NULL)&&(![msgDate isEqualToString:@"--Please Select--"])) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *date = [dateFormatter dateFromString:msgDate];
        [_datePickerView setDate:date animated:YES ];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - action
- (IBAction)dateChange:(id)sender
{
    if (_delegate != Nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *pickerDate = [dateFormatter stringFromDate:[_datePickerView date]];
        
        
        msgDate = [NSString stringWithFormat:@"%@",pickerDate];
    }
}

- (IBAction)donePressed:(id)sender
{
    [self calculateAge];
 
    
    
    
}

-(void)calculateAge
{
    //format in year
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];
    NSString *birthYear = [dateFormatter stringFromDate:[_datePickerView date]];
    
    [dateFormatter setDateFormat:@"MM"];
    NSString *currentMonth = [dateFormatter stringFromDate:[NSDate date]];
    NSString *birthMonth = [dateFormatter stringFromDate:[_datePickerView date]];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];
    NSString *birthDay = [dateFormatter stringFromDate:[_datePickerView date]];
    
    int yearN = [currentYear intValue];
    int yearB = [birthYear intValue];
    int monthN = [currentMonth intValue];
    int monthB = [birthMonth intValue];
    int dayN = [currentDay intValue];
    int dayB = [birthDay intValue];
    
    int ALB = yearN - yearB;
    int newALB;
    int newANB;
    
    NSLog(@"yearN %i yearB %i",yearN,yearB);
    
    if (yearN > yearB)
    {
        if (monthN < monthB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN < dayB) {
            newALB = ALB - 1;
        } else {
            newALB = ALB;
        }
        
        if (monthN > monthB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN >= dayB) {
            newANB = ALB + 1;
        } else {
            newANB = ALB;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d",newALB];
        Age = newALB;
        ANB = newANB;
    }
    else if (yearN == yearB)
    {
        if (monthN > monthB) {
            newALB = monthN - monthB;
            msgAge = [[NSString alloc] initWithFormat:@"%d months",newALB];
            
        } else if (monthN == monthB && dayB<dayN) {
            newALB = dayN - dayB;
            msgAge = [[NSString alloc] initWithFormat:@"%d days",newALB];
        }
        Age = 0;
        ANB = 1;
    }
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    if ((yearN<yearB)||(yearN==yearB && monthN<monthB)||(yearN==yearB && monthN==monthB && dayN<dayB)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Tanggal yang dimasukkan tidak boleh melebihi tanggal hari ini" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [_delegate datePick:self strDate:self.selectedStrDate strAge:self.selectedStrAge intAge:self.selectedIntAge intANB:self.selectedIntANB];
    }
}

-(void)calculateAgeIllustrasi
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    
    NSArray *comm = [dateString componentsSeparatedByString: @"/"];
    NSString *commDay = [comm objectAtIndex:0];
    NSString *commMonth = [comm objectAtIndex:1];
    NSString *commYear = [comm objectAtIndex:2];
    
    
    NSArray *foo = [msgDate componentsSeparatedByString: @"/"];
    NSString *birthDay = [foo objectAtIndex: 0];
    NSString *birthMonth = [foo objectAtIndex: 1];
    NSString *birthYear = [foo objectAtIndex: 2];
    
    int yearN = [commYear intValue];
    int yearB = [birthYear intValue];
    int monthN = [commMonth intValue];
    int monthB = [birthMonth intValue];
    int dayN = [commDay intValue];
    int dayB = [birthDay intValue];
    
    int ALB = yearN - yearB;
    int newALB;
    int newANB;
    
    
    if (yearN > yearB) {
        if (monthN < monthB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN < dayB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN == dayB) { //edited by heng
            newALB = ALB ;  //edited by heng
        } else {
            newALB = ALB;
        }
        
        if (monthN > monthB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN > dayB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN == dayB) { // edited by heng
            newANB = ALB; //edited by heng
        } else {
            newANB = ALB;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d",newALB];
        Age = newALB;
        ANB = newANB;
    } else if (yearN == yearB) {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectDate = msgDate;
        NSDate *startDate = [dateFormatter dateFromString:selectDate];
        
        NSDate *endDate = [dateFormatter dateFromString:dateString];
        
        unsigned flags = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        int diffDays = [difference day];
        
        msgAge = [[NSString alloc] initWithFormat:@"%d days",diffDays];
        
        Age = 0;
        ANB = 1;
    } else {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectDate = msgDate;
        NSDate *startDate = [dateFormatter dateFromString:selectDate];
        
        NSDate *endDate = [dateFormatter dateFromString:dateString];
        
        unsigned flags = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        int diffDays = [difference day];
        
        Age = 0;
        ANB = 1;
    }
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *selectDate = msgDate;
    NSDate *startDate = [dateFormatter dateFromString:selectDate];
    
    NSDate *endDate = [dateFormatter dateFromString:dateString];
    
    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    int diffDays = [difference day];
    
    Age = 0;
    ANB = 1;

}

-(NSString *)selectedStrDate
{
    if ((msgDate==NULL)||([msgDate isEqualToString:@"--Please Select--"])){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *pickerDate = [dateFormatter stringFromDate:[_datePickerView date]];
        
        msgDate = [NSString stringWithFormat:@"%@",pickerDate];
    }
    return msgDate;
}

-(NSString *)selectedStrAge
{
    return msgAge;
}

-(int)selectedIntAge
{
    return Age;
}

-(int)selectedIntANB
{
    return ANB;
}

#pragma mark - memory
- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setDatePickerView:nil];
    [self setMsgDate:nil];
    [self setMsgAge:nil];
    [super viewDidUnload];
}

@end
