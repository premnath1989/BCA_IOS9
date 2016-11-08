#import <UIKit/UIKit.h>

@class ExtraPremi;
@protocol ExtraPremiDelegate
-(void)Planlisting:(ExtraPremi *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc;
@end

@interface ExtraPremi : UITableViewController {
    NSUInteger selectedIndex;
    id <ExtraPremiDelegate> delegate;
}

@property (retain, nonatomic) NSMutableArray *ListOfPlan;
@property (retain, nonatomic) NSMutableArray *ListOfCode;
@property (nonatomic,strong) id <ExtraPremiDelegate> delegate;

@property (nonatomic,strong) id TradOrEver;
@property (readonly) NSString *selectedCode;
@property (readonly) NSString *selectedDesc;

@end