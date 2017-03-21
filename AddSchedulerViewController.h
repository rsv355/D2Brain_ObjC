//
//  AddSchedulerViewController.h
//  D2brain
//
//  Created by webmyne systems on 06/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@class AddSchedulerViewController;
@protocol AddSchedulerDelegate <NSObject>

@required
-(void)SchedulerAdded:(BOOL)success;
@end


@interface AddSchedulerViewController : UIViewController{
}

@property (nonatomic, assign) id <AddSchedulerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISwitch *switchScheduler;
- (IBAction)switchScheduler:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtSchedulerName;
@property (weak, nonatomic) IBOutlet UITextField *txtComponentName;
@property (weak, nonatomic) IBOutlet UITextField *txtScehdulDate;
@property (weak, nonatomic) IBOutlet UITextField *txtScehdulTime;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
- (IBAction)btnCanclePicker:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnHeaderBack;
- (IBAction)btnHeaderBack:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *btnCreateScheduler;
- (IBAction)btnCreateScheduler:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property(strong,nonatomic)DataBaseFile *dbHandler;
@end
