//
//  AnalisaKebutuhanNasabahViewController.m
//  BLESS
//
//  Created by Basvi on 6/17/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AnalisaKebutuhanNasabahViewController.h"

@interface AnalisaKebutuhanNasabahViewController ()

@end

@implementation AnalisaKebutuhanNasabahViewController{
    IBOutlet UIButton* buttonProteksi;
    IBOutlet UIButton* buttonPensiun;
    IBOutlet UIButton* buttonPendidikan;
    IBOutlet UIButton* buttonWarisan;
    IBOutlet UIButton* buttonInvestasi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionChangeTabPage:(UIButton *)sender{
    if (sender==buttonProteksi){
    
    }
    else if (sender==buttonPensiun){
    
    }
    else if (sender==buttonPendidikan){
        
    }
    else if (sender==buttonWarisan){
        
    }
    else if (sender==buttonInvestasi){
        
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
