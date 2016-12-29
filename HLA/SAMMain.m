//
//  SAMMain.m
//  BLESS
//
//  Created by Basvi on 12/20/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMMain.h"
#import "CarouselViewController.h"
#import "SAMDashboardViewController.h"

@interface SAMMain ()

@end

@implementation SAMMain{
    CarouselViewController *viewControllerHome;
    
    SAMDashboardViewController *viewControllerSAMDashboard;
    
    UIAlertController *alertController;
    
    BOOL isInEditMode;
}
@synthesize viewNavigation;
@synthesize buttonHome;

-(void)viewWillAppear:(BOOL)animated{
    [self loadMainView];
}

-(void)viewDidAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    isInEditMode = false;
    
    [viewNavigation setupStyleSAM];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
    viewControllerHome = [mainStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
    
    UIStoryboard *samStoryboard = [UIStoryboard storyboardWithName:@"SAMStoryboard" bundle:Nil];
    viewControllerSAMDashboard = [samStoryboard instantiateViewControllerWithIdentifier:@"SAMRootVC"];
    
    [buttonHome setTitle:NSLocalizedString(@"BUTTON_HOME", nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMainView{
    viewControllerSAMDashboard.view.frame = self.viewContent.bounds;
    [self addChildViewController:viewControllerSAMDashboard];
    [self.viewContent addSubview:viewControllerSAMDashboard.view];
}

- (IBAction)actionGoToHome:(id)sender
{
    // CarouselViewController* viewController = [[CarouselViewController alloc] initWithNibName:@"SPAJ Add Detail" bundle:nil];
    // [self presentViewController:viewController animated:true completion:nil];
    if (isInEditMode){
        NSString* message=@"Anda sedang berada pada menu input Data. Yakin ingin keluar tanpa menyimpan data ?";
        alertController = [UIAlertController alertControllerWithTitle:@"Peringatan" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES
                                     completion:^{
                                         [self presentViewController:viewControllerHome animated:NO completion:Nil];
                                     }];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
    }
    else{
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     [self presentViewController:viewControllerHome animated:NO completion:Nil];
                                 }];
    }
    
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
