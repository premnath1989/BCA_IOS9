//
//  FormTenagaPenjualViewController.m
//  BLESS
//
//  Created by Basvi on 9/20/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "FormTenagaPenjualViewController.h"

@interface FormTenagaPenjualViewController (){
    NSMutableArray *arrayCollectionInsurancePurchaseReason;
    NSMutableArray *arrayCollectionSelectedInsurancePurchaseReason;
    
    NSString* buttonInsurancePurpose;
}

@end

@implementation FormTenagaPenjualViewController
@synthesize dictTransaction;

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 819, 724);
    [self.view.superview setBackgroundColor:[UIColor clearColor]];
}

-(void)viewDidLayoutSubviews{
    [scrollViewForm setContentSize:CGSizeMake(stackViewForm.frame.size.width, stackViewForm.frame.size.height)];
}

- (void)viewDidLoad {
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    [super viewDidLoad];
    functionUserInterface = [[UserInterface alloc] init];
    allAboutPDFFunctions = [[AllAboutPDFFunctions alloc]init];
    
    [collectionReasonInsurancePurchase registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self intializeArrayInsuranceReason];
    
    [textFieldPolicyHolder setTextFieldName:@"textFieldPolicyHolder"];
    [textFieldInsured setTextFieldName:@"textFieldInsured"];
    [textFieldSPAJNumber setTextFieldName:@"textFieldSPAJNumber"];
    
    [segmentRelation setSegmentName:@"segmentRelation"];
    [segmentDurationKnowPolicyHolder setSegmentName:@"segmentDurationKnowPolicyHolder"];
    [segmentIs3 setSegmentName:@"segmentIs3"];
    [segmentIs4 setSegmentName:@"segmentIs4"];
    [segmentIs5 setSegmentName:@"segmentIs5"];
    [segmentIs6 setSegmentName:@"segmentIs6"];
    [segmentIs7 setSegmentName:@"segmentIs7"];
    [segmentIs8 setSegmentName:@"segmentIs8"];
    [segmentIs9 setSegmentName:@"segmentIs9"];
    [segmentIs10 setSegmentName:@"segmentIs10"];
    [segmentIs11 setSegmentName:@"segmentIs11"];
    [segmentIs12 setSegmentName:@"segmentIs12"];
    [segmentIs13 setSegmentName:@"segmentIs13"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)intializeArrayInsuranceReason{
    arrayCollectionInsurancePurchaseReason = [[NSMutableArray alloc]initWithObjects:@"Tabungan",@"Proteksi",@"Investasi",@"Pendidikan",@"Lainnya", nil];
    arrayCollectionSelectedInsurancePurchaseReason = [[NSMutableArray alloc]initWithObjects:@"Not Selected",@"Not Selected",@"Not Selected",@"Not Selected",@"Not Selected",nil];
}

-(IBAction)actionCloseForm:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)actionButtonInsuranceReasonTapped:(ButtonSPAJ *)sender{
    
    for (int i=0;i<[arrayCollectionSelectedInsurancePurchaseReason count];i++){
        if ([[arrayCollectionSelectedInsurancePurchaseReason objectAtIndex:i] isEqualToString:@"Not Selected"]){
            [arrayCollectionSelectedInsurancePurchaseReason removeObjectAtIndex:i];
        }
    }
    
    if ([sender isSelected]){
        [sender setSelected:NO];
        int indexToClear = [arrayCollectionSelectedInsurancePurchaseReason indexOfObject:sender.currentTitle];
        [arrayCollectionSelectedInsurancePurchaseReason removeObjectAtIndex:indexToClear];
    }
    else{
        [arrayCollectionSelectedInsurancePurchaseReason addObject:sender.currentTitle];
        [sender setSelected:YES];
    }
    
    for (int i=0;i<[arrayCollectionInsurancePurchaseReason count];i++){
        if (i >= [arrayCollectionSelectedInsurancePurchaseReason count]){
            [arrayCollectionSelectedInsurancePurchaseReason addObject:@"Not Selected"];
        }
    }
    
    
    NSLog(@"array value %@",arrayCollectionSelectedInsurancePurchaseReason);
}

-(IBAction)getUISwitchValue:(UIButton *)sender{
    NSMutableArray* arrayFormAnswers = [[NSMutableArray alloc]init];

    int i=1;
    for (UIView *view in [stackViewForm subviews]) {
        if (view.tag == 1){
            for (UIView *viewDetail in [view subviews]) {
                if ([viewDetail isKindOfClass:[SegmentSPAJ class]]) {
                    SegmentSPAJ* segmentTemp = (SegmentSPAJ *)viewDetail;
                    NSString *value = [allAboutPDFFunctions GetOutputForYaTidakRadioButton:[segmentTemp titleForSegmentAtIndex:segmentTemp.selectedSegmentIndex]];
                    NSString *elementID = [segmentTemp getSegmentName];
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value];
                    
                    [arrayFormAnswers addObject:dictAnswer];
                    i++;
                }
                
                if ([viewDetail isKindOfClass:[TextFieldSPAJ class]]) {
                    TextFieldSPAJ* textTemp = (TextFieldSPAJ *)viewDetail;
                    NSString *value = textTemp.text;
                    NSString *elementID = [textTemp getTextFieldName];
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value];
                    
                    [arrayFormAnswers addObject:dictAnswer];
                    i++;
                }
            }
        }
    }
    
    for (int x=0;x<[arrayCollectionSelectedInsurancePurchaseReason count];x++){
        NSString *value = [arrayCollectionSelectedInsurancePurchaseReason objectAtIndex:x];
        NSString *elementID = buttonInsurancePurpose;
        
        NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value];
        
        [arrayFormAnswers addObject:dictAnswer];
    }
    
    NSLog(@"answers %@",[allAboutPDFFunctions createDictionaryForSave:arrayFormAnswers]);
    [self savetoDB:[allAboutPDFFunctions createDictionaryForSave:arrayFormAnswers]];
}

- (void)savetoDB:(NSDictionary *)params{
    //add another key to db
    [super savetoDB:params];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrayCollectionInsurancePurchaseReason.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1; // This is the minimum inter item spacing, can be more
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //UIButton* buttonInsurancePurchaseReason = (UIButton *)[cell viewWithTag:indexPath.row];
    ButtonSPAJ* buttonInsurancePurchaseReason = [[ButtonSPAJ alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [buttonInsurancePurchaseReason setButtonName:@"CheckboxInsurancePurpose"];
    buttonInsurancePurpose = [buttonInsurancePurchaseReason getButtonName];
    [buttonInsurancePurchaseReason setTag:indexPath.row];
    [buttonInsurancePurchaseReason setTitle:[arrayCollectionInsurancePurchaseReason objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    [buttonInsurancePurchaseReason setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]  forState:UIControlStateNormal];
    [buttonInsurancePurchaseReason setBackgroundImage:[self imageWithColor:[functionUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]]  forState:UIControlStateSelected];
    
    [buttonInsurancePurchaseReason.titleLabel setFont:[UIFont fontWithName:@"BPReplay" size:17]];
    [buttonInsurancePurchaseReason setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonInsurancePurchaseReason setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    
    [buttonInsurancePurchaseReason addTarget:self
                                              action:@selector(actionButtonInsuranceReasonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:buttonInsurancePurchaseReason];
    
    return cell;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
