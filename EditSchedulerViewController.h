//
//  EditSchedulerViewController.h
//  D2brain
//
//  Created by webmyne systems on 07/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@protocol BackToSchedulerListViewDelegate <NSObject>

@required
- (void)reloadDataFromController;

@end

@interface EditSchedulerViewController : UIViewController

@property (nonatomic, weak) id<BackToSchedulerListViewDelegate> delegate;


@property (weak, nonatomic) IBOutlet UISwitch *switchScheduler;
- (IBAction)switchScheduler:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtSchedulerName;
@property (weak, nonatomic) IBOutlet UITextField *txtComponentName;
@property (weak, nonatomic) IBOutlet UITextField *txtScehdulDate;
@property (weak, nonatomic) IBOutlet UITextField *txtScehdulTime;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(strong,nonatomic)DataBaseFile *dbHandler;

- (IBAction)btnClose:(id)sender;
- (IBAction)btnSaveScheduler:(id)sender;

@property (strong, nonatomic)NSArray *dataArr;
@property (strong, nonatomic)NSString *scheduler_id;
@end
