//
//  SchedulerTableViewCell.h
//  D2brain
//
//  Created by webmyne systems on 07/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchedulerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblSchedulerName;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedulerComponentName;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedulerTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedulerTimeCount;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteScheduler;
@property (weak, nonatomic) IBOutlet UIButton *btnEditScheduler;
@property (weak, nonatomic) IBOutlet UISwitch *switchScheduler;

//----LISTVIEW

@property (weak, nonatomic) IBOutlet UILabel *lblSchedulerListName;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedulerListComponentName;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedulerListTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedulerListTimeCount;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteSchedulerList;
@property (weak, nonatomic) IBOutlet UIButton *btnEditSchedulerList;
@property (weak, nonatomic) IBOutlet UISwitch *switchSchedulerList;
@end
