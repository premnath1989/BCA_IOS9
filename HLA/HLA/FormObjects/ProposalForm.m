//
//  ProposalForm.m
//  MPOS
//
//  Created by compurex on 1/9/14.
//  Copyright (c) 2014 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ProposalForm.h"
#import "NDHTMLtoPDF2.h"
@implementation ProposalForm{
    NSMutableString *htmlContent;
    NSMutableString *referenceNo;
}
@synthesize PDFGenerator;
-(void)GenerateProposalPDF:(NSDictionary*)DataDictionary RNNumber:(NSMutableString *)RNNumber
{
    
    
    htmlContent = [[NSMutableString alloc]initWithString:[NSMutableString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"index1" ofType:@"html" inDirectory:@"ProposalForm"]
                                                                                          encoding: NSUTF8StringEncoding
                                                                                             error: nil]];
    referenceNo = [[NSMutableString alloc]init];
    referenceNo = RNNumber;
    NSString *SearchID;
    NSRange SearchIDRange;
    NSString *newValue;
    
    for (id key in DataDictionary) {
        if([key isEqualToString:@"ReferenceNo"]){
            referenceNo = [DataDictionary objectForKey:key];
        }else{
            referenceNo =  RNNumber;
        }
        
         
        if([[NSString stringWithFormat:@"%@",[DataDictionary objectForKey:key]] isEqualToString:@"Selection-Yes"] || [[NSString stringWithFormat:@"%@",[DataDictionary objectForKey:key]] isEqualToString:@"Selection-No"]){
           
            if([[NSString stringWithFormat:@"%@",[DataDictionary objectForKey:key]] isEqualToString:@"Selection-Yes"]){
                SearchID = [NSString stringWithFormat:@"<ul type=\"circle\" id=\"%@\"",key];
                SearchIDRange = [htmlContent rangeOfString: SearchID
                                                   options: NSLiteralSearch];
                newValue = [NSString stringWithFormat:@"<ul type=\"disc\" id=\"%@\"",key];
                
                 
            }
        }else{
            SearchID = [NSString stringWithFormat:@"id=\"%@\"></span>",key];
            SearchIDRange = [htmlContent rangeOfString: SearchID
                                               options: NSLiteralSearch];
            newValue = [NSString stringWithFormat:@"id=\"%@\">%@</span>",key,[DataDictionary objectForKey:key]];
              
        }
        
        // while (SearchIDRange.location != NSNotFound) {
        if (SearchIDRange.location != NSNotFound) {
            
            [htmlContent replaceCharactersInRange: SearchIDRange
                                       withString: newValue];
            SearchIDRange = [htmlContent rangeOfString: SearchID];
        }
    }    
}
@end
