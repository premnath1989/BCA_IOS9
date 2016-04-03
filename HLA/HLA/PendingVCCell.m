//
//  PendingVCCell.m
//  MPOS
//
//  Created by Basvi on 14/01/14.
//  Copyright (c) 2014 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PendingVCCell.h"
#import "WebViewViewController.h"

@implementation PendingVCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Payment_Button:(id)sender
{
	{
		//[self dismissViewControllerAnimated:YES completion:nil];
		//	WebViewViewController *controller=[[WebViewViewController alloc]init];
		//	[self.navigationController presentModalViewController:controller animated:YES];
		
		
//		WebViewViewController *controller = [[WebViewViewController alloc]
//											 initWithNibName:@"WebViewViewController"
//											 bundle:nil];
//		
//		//controller.delegate = self;
//		controller.modalPresentationStyle = UIModalPresentationPageSheet;
//		[self presentViewController:controller animated:YES completion:Nil];
	
		
		
	}
}
@end
