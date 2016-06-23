//
//  SPAJ Launch.m
//  Bless SPAJ
//
//  Created by Ibrahim on 20/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//

#import "SPAJ Launch.h"
#import "SPAJ Main.h"

@interface SPAJLaunch ()

@end

@implementation SPAJLaunch

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    SPAJMain *viewController=[[SPAJMain alloc]initWithNibName:@"SPAJ Main" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
