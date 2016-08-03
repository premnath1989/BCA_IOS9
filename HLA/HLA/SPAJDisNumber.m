//
//  SPAJDisNumber.m
//  BLESS
//
//  Created by Erwin Lim  on 8/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import <Foundation/Foundation.h>
#import "SPAJDisNumber.h"

@implementation SPAJDisNumber

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)btnClose:(id)sender
{
    [self dismissModalViewControllerAnimated:YES ];
}

- (IBAction)btnSync:(id)sender
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://mposws.azurewebsites.net/Service2.svc/AllocateSpajForAgent?agentCode=11600026"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:data //1
                                      
                                      options:kNilOptions
                                      error:&error];
                NSLog(@"%@",json);
            }] resume];


}

@end