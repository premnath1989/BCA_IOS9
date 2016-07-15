//
//  AnalisaKebutuhanNasabahViewController.m
//  BLESS
//
//  Created by Basvi on 6/17/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AnalisaKebutuhanNasabahViewController.h"
#import "AnalisaKebutuhanPensiunViewController.h"
#import "AnalisaKebutuhanWarisanViewController.h"
#import "AnalisaKebutuhanProteksiViewController.h"
#import "AnalisaKebutuhanInvestasiViewController.h"
#import "AnalisaKebutuhanPendidikanViewController.h"
#import "ModelCFFHtml.h"

@interface AnalisaKebutuhanNasabahViewController (){
    AnalisaKebutuhanPensiunViewController *pensiunVC;
    AnalisaKebutuhanWarisanViewController *warisanVC;
    AnalisaKebutuhanProteksiViewController *proteksiVC;
    AnalisaKebutuhanInvestasiViewController *investasiVC;
    AnalisaKebutuhanPendidikanViewController *pendidikanVC;
    
    ModelCFFHtml* modelCFFHtml;
}

@end

@implementation AnalisaKebutuhanNasabahViewController{
    IBOutlet UIButton* buttonProteksi;
    IBOutlet UIButton* buttonPensiun;
    IBOutlet UIButton* buttonPendidikan;
    IBOutlet UIButton* buttonWarisan;
    IBOutlet UIButton* buttonInvestasi;
    
    IBOutlet UIView *childView;
}
@synthesize prospectProfileID,cffTransactionID,cffID,cffHeaderSelectedDictionary;
- (void)viewDidLoad {
    [super viewDidLoad];
    modelCFFHtml=[[ModelCFFHtml alloc]init];
    
    pensiunVC = [[AnalisaKebutuhanPensiunViewController alloc]initWithNibName:@"AnalisaKebutuhanPensiunViewController" bundle:nil];
    warisanVC = [[AnalisaKebutuhanWarisanViewController alloc]initWithNibName:@"AnalisaKebutuhanWarisanViewController" bundle:nil];
    proteksiVC = [[AnalisaKebutuhanProteksiViewController alloc]initWithNibName:@"AnalisaKebutuhanProteksiViewController" bundle:nil];
    investasiVC = [[AnalisaKebutuhanInvestasiViewController alloc]initWithNibName:@"AnalisaKebutuhanInvestasiViewController" bundle:nil];
    pendidikanVC = [[AnalisaKebutuhanPendidikanViewController alloc]initWithNibName:@"AnalisaKebutuhanPendidikanViewController" bundle:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionChangeTabPage:(UIButton *)sender{
    if (sender==buttonProteksi){
        cffID = [cffHeaderSelectedDictionary valueForKey:@"ProteksiCFFID"];
        NSMutableArray *arrayHtml = [modelCFFHtml selectHtmlData:[cffID intValue] HtmlSection:@"PRT"];
        proteksiVC.prospectProfileID = prospectProfileID;
        proteksiVC.cffTransactionID  = cffTransactionID;
        proteksiVC.cffID = cffID;
        proteksiVC.htmlFileName = [[arrayHtml objectAtIndex:0]valueForKey:@"CFFHtmlName"];
        if ([proteksiVC.view isDescendantOfView:childView]){
            [childView bringSubviewToFront:proteksiVC.view];
        }
        else{
            [childView addSubview:proteksiVC.view];
        }
    }
    else if (sender==buttonPensiun){
        cffID = [cffHeaderSelectedDictionary valueForKey:@"PensiunCFFID"];
        NSMutableArray *arrayHtml = [modelCFFHtml selectHtmlData:[cffID intValue] HtmlSection:@"PSN"];
        pensiunVC.prospectProfileID = prospectProfileID;
        pensiunVC.cffTransactionID  = cffTransactionID;
        pensiunVC.cffID = cffID;
        pensiunVC.htmlFileName = [[arrayHtml objectAtIndex:0]valueForKey:@"CFFHtmlName"];
        if ([pensiunVC.view isDescendantOfView:childView]){
            [childView bringSubviewToFront:pensiunVC.view];
        }
        else{
            [childView addSubview:pensiunVC.view];
        }
    }
    else if (sender==buttonPendidikan){
        cffID = [cffHeaderSelectedDictionary valueForKey:@"PendidikanCFFID"];
        NSMutableArray *arrayHtml = [modelCFFHtml selectHtmlData:[cffID intValue] HtmlSection:@"PND"];
        pendidikanVC.prospectProfileID = prospectProfileID;
        pendidikanVC.cffTransactionID  = cffTransactionID;
        pendidikanVC.cffID = cffID;
        pendidikanVC.htmlFileName = [[arrayHtml objectAtIndex:0]valueForKey:@"CFFHtmlName"];
        if ([pendidikanVC.view isDescendantOfView:childView]){
            [childView bringSubviewToFront:pendidikanVC.view];
        }
        else{
            [childView addSubview:pendidikanVC.view];
        }
    }
    else if (sender==buttonWarisan){
        cffID = [cffHeaderSelectedDictionary valueForKey:@"WarisanCFFID"];
        NSMutableArray *arrayHtml = [modelCFFHtml selectHtmlData:[cffID intValue] HtmlSection:@"WRS"];
        warisanVC.prospectProfileID = prospectProfileID;
        warisanVC.cffTransactionID  = cffTransactionID;
        warisanVC.cffID = cffID;
        warisanVC.htmlFileName = [[arrayHtml objectAtIndex:0]valueForKey:@"CFFHtmlName"];
        if ([warisanVC.view isDescendantOfView:childView]){
            [childView bringSubviewToFront:warisanVC.view];
        }
        else{
            [childView addSubview:warisanVC.view];
        }
    }
    else if (sender==buttonInvestasi){
        cffID = [cffHeaderSelectedDictionary valueForKey:@"InvestasiCFFID"];
        NSMutableArray *arrayHtml = [modelCFFHtml selectHtmlData:[cffID intValue] HtmlSection:@"INV"];
        investasiVC.prospectProfileID = prospectProfileID;
        investasiVC.cffTransactionID  = cffTransactionID;
        investasiVC.cffID = cffID;
        investasiVC.htmlFileName = [[arrayHtml objectAtIndex:0]valueForKey:@"CFFHtmlName"];
        if ([investasiVC.view isDescendantOfView:childView]){
            [childView bringSubviewToFront:investasiVC.view];
        }
        else{
            [childView addSubview:investasiVC.view];
        }
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
