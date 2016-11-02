//
//  SPAJSubmissionFiles.m
//  BLESS
//
//  Created by Erwin Lim  on 8/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPAJSubmissionFiles.h"

@implementation SPAJSubmissionFiles{
    
}


-(void)xmltoFile:(NSMutableDictionary *)dictInfo path:(NSString *)filePath
{
    NSError *error;
    NSString *textParsed = [self parseXML:dictInfo text:@""];
    [textParsed writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (NSString *) parseXML:(NSMutableDictionary *)dictInfo text:(NSString *)text{
    for(NSString *root in [dictInfo allKeys]){
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<%@>",root]];
        if([[dictInfo valueForKey:root] isKindOfClass:[NSMutableDictionary class]]){
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",[self parseXML:[dictInfo valueForKey:root] text:@""]]];
        }else{
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",[dictInfo valueForKey:root]]];
        }
        NSArray *substrings = [root componentsSeparatedByString:@" "];
        NSString *nodeTitle = [substrings objectAtIndex:0];
        text = [text stringByAppendingString:[NSString stringWithFormat:@"</%@>",nodeTitle]];
    }
    return text;
}

@end