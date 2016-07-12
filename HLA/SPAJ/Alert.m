//
//  ViewController.m
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Alert.h"


// DECLARATION

@implementation Alert

    // INFORMATION

    - (UIAlertController *) alertInformation : (NSString *)stringTitle stringMessage : (NSString *) stringMessage
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:stringTitle message:stringMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* alertActionClose = [UIAlertAction actionWithTitle:NSLocalizedString(@"BUTTON_CLOSE", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        [alertController addAction: alertActionClose];
        
        return alertController;
    };


    // RESPONE

    - (UIAlertController *) alertTableDelete : (NSString *) stringTitle stringMessage : (NSString *) stringMessage
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:stringTitle message:stringMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* alertActionDelete = [UIAlertAction actionWithTitle:NSLocalizedString(@"BUTTON_DELETE", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {}];
        [alertController addAction: alertActionDelete];
        
        UIAlertAction* alertActionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"BUTTON_CANCEL", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        [alertController addAction: alertActionCancel];

        return alertController;
    }


    // INPUT

    - (UIAlertController *) alertInputTextField:(NSString *)stringTitle stringMessage : (NSString *) stringMessage stringPlaceholder : (NSString *) stringPlaceholder
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:stringTitle message:stringMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* alertActionSubmit = [UIAlertAction actionWithTitle:NSLocalizedString(@"BUTTON_SUBMIT", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {}];
        [alertController addAction: alertActionSubmit];
        
        UIAlertAction* alertActionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"BUTTON_CANCEL", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        [alertController addAction: alertActionCancel];
        
        return alertController;
    }

@end