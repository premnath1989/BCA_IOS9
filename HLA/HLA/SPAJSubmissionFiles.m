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

-(void)xmltoFile:(NSString *)text path:(NSString *)filePath
{
    NSError *error;
    
    
    [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (void) parseXML:(NSMutableDictionary *)dictInfo text:(NSString *)text{
    for(NSString *root in [dictInfo allKeys]){
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",root]];
        [dictInfo valueForKey:root];        
    }
}

@end